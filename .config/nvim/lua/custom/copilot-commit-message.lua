local Spinner = {
  timer = nil,
  is_running = false,
  characters = { "◜", "◠", "◝", "◞", "◡", "◟" },
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
      Snacks.picker({
        previewer = false,
        layout = {
          preview = false,
          layout = {
            width = 0.5,
            height = 0.6,
          },
        },
        items = items,
        format = function(item)
          local ret = {}

          -- Try matching: style(scope): message
          local style, scope, message = item.text:match("^([%w_-]+)%(([%w_-]+)%)%s*:%s*(.+)$")
          if not style then
            -- Fallback: style: message (no scope)
            style, message = item.text:match("^([%w_-]+)%s*:%s*(.+)$")
          end

          ret[#ret + 1] = { style, "CommitMessageStyle" }

          if scope then
            ret[#ret + 1] = { "(", "Normal" }
            ret[#ret + 1] = { scope, "CommitMessageScope" }
            ret[#ret + 1] = { ")", "Normal" }
          end

          ret[#ret + 1] = { ": " .. message, "SnacksPickerLabel" }

          return ret
        end,
        confirm = function(picker, item)
          picker:close()

          vim.api.nvim_set_current_line(item.text)
        end,
      })
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
