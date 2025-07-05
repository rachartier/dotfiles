local Spinner = {
  timer = nil,
  is_running = false,
  characters = {
    "",
    "",
    "",
    "",
    "",
    "",
  },
  index = 1,
  ns_id = vim.api.nvim_create_namespace("commit_spinner"),
}

function Spinner:new()
  local instance = setmetatable({}, { __index = self })
  return instance
end

function Spinner:start()
  if self.is_running then
    return
  end

  self.timer = vim.uv.new_timer()
  if not self.timer then
    vim.notify("Failed to create timer", vim.log.levels.ERROR)
    return
  end

  self.is_running = true
  self.timer:start(0, 80, function()
    self:update()
  end)
end

function Spinner:update()
  if not self.is_running then
    return
  end

  vim.schedule(function()
    if not self.is_running then
      return
    end
    self.index = (self.index % #self.characters) + 1
    local cursor_line = vim.fn.line(".")
    vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
    vim.api.nvim_buf_set_extmark(0, self.ns_id, cursor_line - 1, 0, {
      virt_text = { { self.characters[self.index] .. " Generating commit message...", "Comment" } },
      virt_text_pos = "overlay",
    })
  end)
end

function Spinner:stop()
  self.is_running = false
  if self.timer then
    self.timer:stop()
    self.timer:close()
    self.timer = nil
    vim.schedule(function()
      vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
    end)
  end
end

local spinner = Spinner:new()
vim.api.nvim_set_hl(
  0,
  "CopilotCommitMessageStyle",
  { fg = require("theme").get_colors().green, bg = "None" }
)
vim.api.nvim_set_hl(
  0,
  "CommitMessageScope",
  { fg = require("theme").get_colors().red, bg = "None" }
)

local function generate_message()
  spinner:start()

  local function callback(obj)
    spinner:stop()

    if obj.code ~= 0 then
      vim.notify("Error generating commit message: " .. obj.stderr, vim.log.levels.ERROR)
      return
    end

    local items = {}

    for _, line in ipairs(vim.split(obj.stdout, "\n")) do
      if line ~= "" then
        items[#items + 1] = {
          idx = #items,
          score = #items,
          text = line:gsub("^[0-9]+: ", ""),
        }
      end
    end

    vim.schedule(function()
      local parent_win = vim.api.nvim_get_current_win()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = "gitcommit"
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].swapfile = false
      vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        vim.tbl_map(function(i)
          return i.text
        end, items)
      )

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.5),
        height = math.floor(vim.o.lines * 0.6),
        row = math.floor((vim.o.lines * 0.2)),
        col = math.floor((vim.o.columns * 0.25)),
        style = "minimal",
        border = "rounded",
        noautocmd = true,
      })

      vim.wo[win].statusline = ""
      vim.wo[win].winbar = ""
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false
      vim.wo[win].signcolumn = "no"

      vim.api.nvim_create_autocmd("BufEnter", {
        buffer = buf,
        callback = function()
          vim.b._copilot_commit_picker_entered = true
        end,
      })

      vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = buf,
        callback = function()
          vim.b._copilot_commit_picker_closed = true
        end,
      })

      vim.keymap.set("n", "<CR>", function()
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
        local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_set_current_win(parent_win)
        vim.api.nvim_set_current_line(line)
      end, { buffer = buf, nowait = true })
    end)
  end

  vim.system({
    "copilot-cli",
    "--action",
    "lazygit-conventional-commit",
    "--path",
    ".",
  }, { text = true }, callback)
end

require("utils").on_event("FileType", function()
  vim.keymap.set({ "n", "i" }, "<M-a>", function()
    generate_message()
  end)
end, {
  target = "gitcommit",
})
