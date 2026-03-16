local M = {}
local ns = vim.api.nvim_create_namespace("plugin_dashboard")

local S_CHECKING = "~"
local S_UPDATE   = "↑"
local S_DONE     = "·" -- covers both "up to date" and "no remote info"

local STATUS_HL = {
  [S_CHECKING] = "Comment",
  [S_UPDATE]   = "DiagnosticWarn",
  [S_DONE]     = "Comment",
}

local STATUS_PRIORITY = { [S_UPDATE] = 0, [S_CHECKING] = 1, [S_DONE] = 2 }

local COMMIT_INDENT = "     "

local function default_layout()
  local w = math.floor(vim.o.columns * vim.g.float_width)
  local h = math.floor(vim.o.lines   * vim.g.float_height)
  return {
    row    = math.floor((vim.o.lines   - h) / 2),
    col    = math.floor((vim.o.columns - w) / 2),
    width  = w,
    height = h,
  }
end

local function build_content(plugins, max_name, statuses, logs)
  local lines, marks = {}, {}

  local active_count = 0
  for _, p in ipairs(plugins) do
    if p.active then active_count = active_count + 1 end
  end

  local header = string.format("  %d plugins  ·  %d active  ·  %d inactive",
    #plugins, active_count, #plugins - active_count)
  lines[#lines + 1] = header
  marks[#marks + 1] = { 0, 0, #header, "Title" }
  lines[#lines + 1] = ""

  local sorted = vim.list_slice(plugins, 1)
  table.sort(sorted, function(a, b)
    local pa = STATUS_PRIORITY[statuses[a.spec.name] or S_CHECKING] or 1
    local pb = STATUS_PRIORITY[statuses[b.spec.name] or S_CHECKING] or 1
    if pa ~= pb then return pa < pb end
    return a.spec.name < b.spec.name
  end)

  local row_fmt     = " %s %-" .. max_name .. "s  %s  %s"
  local prev_status = nil
  for _, p in ipairs(sorted) do
    local icon   = p.active and "●" or "○"
    local rev    = p.rev and p.rev:sub(1, 6) or "------"
    local status = statuses[p.spec.name] or S_CHECKING

    if prev_status == S_UPDATE and status ~= S_UPDATE then
      local sep_lnum = #lines
      local sep      = " " .. string.rep("─", max_name + 13)
      lines[#lines + 1] = sep
      marks[#marks + 1] = { sep_lnum, 0, #sep, "Comment" }
    end
    prev_status = status

    local lnum       = #lines
    local rev_col    = 1 + #icon + 1 + max_name + 2
    local status_col = rev_col + #rev + 2
    lines[#lines + 1] = row_fmt:format(icon, p.spec.name, rev, status)
    marks[#marks + 1] = { lnum, 1,          1 + #icon,            p.active and "DiagnosticOk" or "Comment" }
    marks[#marks + 1] = { lnum, rev_col,    rev_col + #rev,       "Comment" }
    marks[#marks + 1] = { lnum, status_col, status_col + #status, STATUS_HL[status] or "Comment" }

    if status == S_UPDATE then
      for _, commit in ipairs(logs[p.spec.name] or {}) do
        local clnum = #lines
        lines[#lines + 1] = COMMIT_INDENT .. commit
        marks[#marks + 1] = { clnum, #COMMIT_INDENT, #COMMIT_INDENT + 7, "Comment" }
      end
    end
  end

  lines[#lines + 1] = ""
  local footer      = "  [u] update all   [q] close"
  local footer_lnum = #lines
  lines[#lines + 1] = footer
  marks[#marks + 1] = { footer_lnum, 0, #footer, "Comment" }

  return lines, marks
end

local function render(buf, plugins, max_name, statuses, logs)
  if not vim.api.nvim_buf_is_valid(buf) then return 0, 0 end

  local lines, marks = build_content(plugins, max_name, statuses, logs)

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, m in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buf, ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
  end
  vim.bo[buf].modifiable = false

end

local function make_title(statuses, total)
  local done, updates = 0, 0
  for _, s in pairs(statuses) do
    done = done + 1
    if s == S_UPDATE then updates = updates + 1 end
  end
  if done < total then
    return string.format(" 󰏖 Plugins  checking %d/%d ", done, total)
  elseif updates > 0 then
    return string.format(" 󰏖 Plugins  %d update%s ", updates, updates > 1 and "s" or "")
  end
  return " 󰏖 Plugins  up to date "
end

function M.open()
  local plugins  = vim.pack.get()
  local max_name = 0
  for _, p in ipairs(plugins) do
    max_name = math.max(max_name, #p.spec.name)
  end

  local statuses = {}
  local logs     = {}

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"

  render(buf, plugins, max_name, statuses, logs)
  local win = vim.api.nvim_open_win(buf, true, vim.tbl_extend("force", default_layout(), {
    relative  = "editor",
    border    = "rounded",
    title     = " 󰏖 Plugins  checking… ",
    title_pos = "center",
    style     = "minimal",
  }))
  vim.wo[win].cursorline = true
  vim.wo[win].wrap       = true

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q",     close, { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })
  vim.keymap.set("n", "u", function() close(); vim.pack.update() end, { buffer = buf, silent = true })

  local function refresh()
    vim.schedule(function()
      render(buf, plugins, max_name, statuses, logs)
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, vim.tbl_extend("force", default_layout(), {
          relative  = "editor",
          title     = make_title(statuses, #plugins),
          title_pos = "center",
        }))
      end
    end)
  end

  for _, p in ipairs(plugins) do
    local name = p.spec.name
    local rev  = p.rev

    -- Try origin/HEAD first, then each known branch as fallback
    local candidates = { "refs/remotes/origin/HEAD" }
    for _, b in ipairs(p.branches or {}) do
      candidates[#candidates + 1] = "refs/remotes/origin/" .. b
    end

    local function fetch_log(target_rev)
      vim.system(
        { "git", "-C", p.path, "log", rev .. ".." .. target_rev, "--format=%h %s", "--no-decorate" },
        { text = true },
        function(log_r)
          if log_r.code == 0 and log_r.stdout ~= "" then
            logs[name] = vim.split(log_r.stdout, "\n", { trimempty = true })
          end
          refresh()
        end
      )
    end

    local function check_refs(refs)
      if #refs == 0 then
        statuses[name] = S_DONE
        refresh()
        return
      end
      local remaining = vim.list_slice(refs, 1)
      local ref = table.remove(remaining, 1)
      vim.system({ "git", "-C", p.path, "rev-parse", ref }, { text = true }, function(r)
        if r.code ~= 0 or r.stdout == "" then
          check_refs(remaining)
          return
        end
        local remote_rev = r.stdout:gsub("%s+", "")
        if remote_rev == rev then
          statuses[name] = S_DONE
          refresh()
          return
        end
        statuses[name] = S_UPDATE
        fetch_log(remote_rev)
      end)
    end

    -- For tag-pinned plugins: compare rev against the latest available tag commit.
    -- For HEAD-pinned plugins: compare against origin/HEAD and known branch refs.
    local function check_tag()
      vim.system({ "git", "-C", p.path, "tag", "--sort=-version:refname" }, { text = true }, function(r)
        local latest_tag = r.code == 0 and vim.split(r.stdout, "\n", { trimempty = true })[1]
        if not latest_tag then
          statuses[name] = S_DONE
          refresh()
          return
        end
        vim.system({ "git", "-C", p.path, "rev-parse", latest_tag .. "^{}" }, { text = true }, function(r2)
          if r2.code ~= 0 or r2.stdout == "" then
            statuses[name] = S_DONE
            refresh()
            return
          end
          local tag_commit = r2.stdout:gsub("%s+", "")
          if tag_commit == rev then
            statuses[name] = S_DONE
            refresh()
            return
          end
          statuses[name] = S_UPDATE
          fetch_log(tag_commit)
        end)
      end)
    end

    vim.system({ "git", "-C", p.path, "fetch", "origin", "--tags", "--quiet" }, { text = true }, function(r)
      if r.code ~= 0 then
        statuses[name] = S_DONE
        refresh()
        return
      end
      -- spec.version nil  → following HEAD/default branch
      -- spec.version set  → pinned to a tag or version range
      if p.spec.version ~= nil and #(p.tags or {}) > 0 then
        check_tag()
      else
        check_refs(candidates)
      end
    end)
  end
end

return M
