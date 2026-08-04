local M = {}

local default_opts = {
  format = "png",
  theme = "default",
  background = "white",
  output_dir = "/tmp",
  open_cmd = nil,
  mmdc = "mmdc",
  width = 1600,
  height = nil,
  config_file = nil,
  auto_width = true,
  mermaid_config = {
    gantt = { useMaxWidth = false },
    flowchart = { useMaxWidth = false },
    sequence = { useMaxWidth = false },
  },
}

local opts = vim.deepcopy(default_opts)

local function get_block_under_cursor()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local fence = "^%s*```+%s*mermaid%s*$"
  local close = "^%s*```+%s*$"

  local start_line
  for i = cur, 1, -1 do
    if lines[i]:match(fence) then
      start_line = i
      break
    end
    if i ~= cur and lines[i]:match(close) then
      break
    end
  end

  if not start_line then
    return nil, "No ```mermaid block found under cursor"
  end

  local end_line
  for i = start_line + 1, #lines do
    if lines[i]:match(close) then
      end_line = i
      break
    end
  end

  if not end_line then
    return nil, "Unterminated ```mermaid block"
  end

  if cur <= start_line or cur >= end_line then
    return nil, "Cursor is not inside a ```mermaid block"
  end

  return vim.list_slice(lines, start_line + 1, end_line - 1)
end

local function estimate_width(lines)
  local count = 0
  local max_label = 0
  for _, line in ipairs(lines) do
    local trimmed = line:gsub("^%s+", "")
    if trimmed ~= "" and not trimmed:match("^%%%%") then
      count = count + 1
      if #trimmed > max_label then
        max_label = #trimmed
      end
    end
  end

  local width = math.max(count * 90, max_label * 14)
  width = math.max(width, 1200)
  width = math.min(width, 6000)
  return width
end

local function write_config()
  if opts.config_file then
    return vim.fn.expand(opts.config_file)
  end
  if not opts.mermaid_config then
    return nil
  end
  local tmp = vim.fn.tempname() .. ".json"
  vim.fn.writefile({ vim.json.encode(opts.mermaid_config) }, tmp)
  return tmp
end

local function output_path(src_name)
  local base
  if src_name and src_name ~= "" then
    base = vim.fn.fnamemodify(src_name, ":t:r")
  else
    base = "mermaid_" .. os.time()
  end

  local dir
  if opts.output_dir then
    dir = vim.fn.expand(opts.output_dir)
  elseif src_name and src_name ~= "" then
    dir = vim.fn.fnamemodify(src_name, ":h")
  else
    dir = vim.fn.getcwd()
  end

  return string.format("%s/%s.%s", dir, base, opts.format)
end

local function run_mmdc(in_file, out_file, width)
  local cmd = {
    opts.mmdc,
    "-i",
    in_file,
    "-o",
    out_file,
    "-t",
    opts.theme,
    "-b",
    opts.background,
  }

  if width then
    table.insert(cmd, "-w")
    table.insert(cmd, tostring(width))
  end
  if opts.height then
    table.insert(cmd, "-H")
    table.insert(cmd, tostring(opts.height))
  end
  local cfg = write_config()
  if cfg then
    table.insert(cmd, "-c")
    table.insert(cmd, cfg)
  end

  if vim.fn.executable(opts.mmdc) == 0 then
    vim.notify(
      ("mermaid-render: '%s' not found on PATH (npm i -g @mermaid-js/mermaid-cli)"):format(
        opts.mmdc
      ),
      vim.log.levels.ERROR
    )
    return
  end

  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        local msg = (res.stderr ~= "" and res.stderr) or res.stdout or "unknown error"
        vim.notify("mermaid-render failed:\n" .. msg, vim.log.levels.ERROR)
        return
      end
      vim.notify("mermaid-render: wrote " .. out_file, vim.log.levels.INFO)
      if opts.open_cmd then
        vim.system({ opts.open_cmd, out_file }, { detach = true })
      end
    end)
  end)
end

function M.render()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local name = vim.api.nvim_buf_get_name(buf)
  local ext = name:match("%.([^.]+)$")

  local is_mermaid_file = ft == "mermaid" or ext == "mmd" or ext == "mermaid"

  local out = output_path(name)

  if is_mermaid_file then
    local tmp = vim.fn.tempname() .. ".mmd"
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.fn.writefile(lines, tmp)
    local width = opts.auto_width and estimate_width(lines) or opts.width
    run_mmdc(tmp, out, width)
  else
    local block, err = get_block_under_cursor()
    if not block then
      vim.notify("mermaid-render: " .. err, vim.log.levels.WARN)
      return
    end
    local tmp = vim.fn.tempname() .. ".mmd"
    vim.fn.writefile(block, tmp)
    local width = opts.auto_width and estimate_width(block) or opts.width
    run_mmdc(tmp, out, width)
  end
end

vim.api.nvim_create_user_command("MermaidRender", function()
  M.render()
end, { desc = "Render mermaid diagram from buffer or block under cursor" })
