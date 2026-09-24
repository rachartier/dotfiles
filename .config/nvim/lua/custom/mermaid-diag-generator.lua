local mermaid_config = {
  gantt = { useMaxWidth = false },
  flowchart = { useMaxWidth = false },
  sequence = { useMaxWidth = false },
}

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
      max_label = math.max(max_label, #trimmed)
    end
  end

  return math.min(math.max(count * 90, max_label * 14, 1200), 6000)
end

local function render()
  if vim.fn.executable("mmdc") == 0 then
    vim.notify(
      "mermaid-render: 'mmdc' not found on PATH (npm i -g @mermaid-js/mermaid-cli)",
      vim.log.levels.ERROR
    )
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local ext = name:match("%.([^.]+)$")

  local lines, err
  if vim.bo[buf].filetype == "mermaid" or ext == "mmd" or ext == "mermaid" then
    lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  else
    lines, err = get_block_under_cursor()
    if not lines then
      vim.notify("mermaid-render: " .. err, vim.log.levels.WARN)
      return
    end
  end

  local base = name ~= "" and vim.fn.fnamemodify(name, ":t:r") or ("mermaid_" .. os.time())
  local out_file = "/tmp/" .. base .. ".png"
  local in_file = vim.fn.tempname() .. ".mmd"
  local config_file = vim.fn.tempname() .. ".json"
  vim.fn.writefile(lines, in_file)
  vim.fn.writefile({ vim.json.encode(mermaid_config) }, config_file)

  local cmd = {
    "mmdc",
    "-i",
    in_file,
    "-o",
    out_file,
    "-t",
    "default",
    "-b",
    "white",
    "-w",
    tostring(estimate_width(lines)),
    "-c",
    config_file,
  }

  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        local msg = (res.stderr ~= "" and res.stderr) or res.stdout or "unknown error"
        vim.notify("mermaid-render failed:\n" .. msg, vim.log.levels.ERROR)
        return
      end
      vim.notify("mermaid-render: wrote " .. out_file, vim.log.levels.INFO)
    end)
  end)
end

vim.api.nvim_create_user_command(
  "MermaidRender",
  render,
  { desc = "Render mermaid diagram from buffer or block under cursor" }
)
