vim.pack.add({ "https://github.com/stevearc/oil.nvim" }, { confirm = false })

local loaded = false

local function load()
  if loaded then
    return
  end
  loaded = true

  require("oil").setup({
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    watch_for_changes = true,
    columns = { "icon" },
    float = {
      get_win_title = nil,
      preview_split = "right",
      border = require("config.ui.border").default_border,
      max_width = math.floor(vim.o.columns * vim.g.float_width) - 1,
      max_height = math.floor(vim.o.lines * vim.g.float_height) - 1,
    },
    confirmation = { border = vim.g.float_border },
    keymaps = { ["<BS>"] = { "actions.parent", mode = "n" } },
  })
end

vim.keymap.set("n", "<leader>te", function()
  load()
  vim.cmd("Oil --float")
end, { silent = true, desc = "Open Oil" })
