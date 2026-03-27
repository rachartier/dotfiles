local Spinner = {
  timer = nil,
  is_running = false,
  characters = { "-", "\\", "|", "/" },
  index = 1,
  ns_id = vim.api.nvim_create_namespace("note_tags_spinner"),
}

function Spinner:new()
  local instance = setmetatable({}, { __index = self })
  return instance
end

function Spinner:start(line)
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
    self:update(line)
  end)
end

function Spinner:update(line)
  if not self.is_running then
    return
  end

  vim.schedule(function()
    if not self.is_running then
      return
    end
    self.index = (self.index % #self.characters) + 1
    vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
    vim.api.nvim_buf_set_extmark(0, self.ns_id, line - 1, 0, {
      virt_text = {
        { " " .. self.characters[self.index] .. " Generating tags...", "Comment" },
      },
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

  spinner:start(tags_lnum)

  local function callback(obj)
    spinner:stop()

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
    vim.print("Setting up note tag generation keymap for this buffer")
    vim.keymap.set("n", "<M-e>", generate_tags, { buffer = true, desc = "generate note tags" })
  end,
  desc = "setup note tag generation",
})
