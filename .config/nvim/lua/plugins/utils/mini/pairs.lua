local M = {}

M.disabled_filetypes = {
  "TelescopePrompt",
  "spectre_panel",
  "copilot-chat",
  "ministarter",
  "fzf",
}

function M.setup()
  local MiniPairs = require("mini.pairs")

  MiniPairs.setup({
    modes = { insert = true, command = false, terminal = false },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = M.disabled_filetypes,
    callback = function()
      vim.b.minipairs_disable = true
    end,
  })

  -- Python: typing { after f" or f' creates {} pair (for f-strings)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      MiniPairs.map_buf(0, "i", "{", { action = "open", pair = "{}", neigh_pattern = "[\"']." })
    end,
  })

  -- C#: typing { after $" creates {} pair (for interpolated strings)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
      MiniPairs.map_buf(0, "i", "{", { action = "open", pair = "{}", neigh_pattern = '".' })
    end,
  })
end

return M
