local spinner_line = 1
local spinner = require("custom.spinner").new("Generating tags...", function()
  return spinner_line
end)

local function find_tags_line()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:match("^Tags%s*:") then
      return i
    end
  end
  return nil
end

local function generate_tags()
  local tags_lnum = find_tags_line()
  if not tags_lnum then
    vim.notify("No 'Tags:' line found in buffer", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  spinner_line = tags_lnum
  spinner.start()

  local function callback(obj)
    spinner.stop()

    if obj.code ~= 0 then
      vim.notify("Error generating tags: " .. obj.stderr, vim.log.levels.ERROR)
      return
    end

    local tags = vim.trim(obj.stdout)
    if tags == "" then
      vim.notify("No tags generated", vim.log.levels.WARN)
      return
    end

    vim.schedule(function()
      local current_tags_lnum = find_tags_line()
      if not current_tags_lnum then
        vim.notify("Tags line disappeared during generation", vim.log.levels.ERROR)
        return
      end
      vim.api.nvim_buf_set_lines(0, current_tags_lnum - 1, current_tags_lnum, false, {
        "Tags: " .. tags,
      })
    end)
  end

  vim.system({
    "copilot-cli",
    "--action",
    "note-tags",
    "--prompt",
    content,
  }, { text = true }, callback)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "norg" },
  callback = function()
    vim.keymap.set("n", "<M-e>", generate_tags, { buffer = true, desc = "generate note tags" })
  end,
  desc = "setup note tag generation",
})
