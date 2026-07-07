vim.pack.add({
  "https://github.com/romus204/tree-sitter-manager.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
}, { confirm = false })

local lang_config = require("config.languages")
local utils = require("utils")

local ensure_installed = { "regex", "bash" }
for _, lang in ipairs(lang_config) do
  local filetypes = lang.treesitter or lang.filetypes or {}
  for _, filetype in ipairs(filetypes) do
    if
      filetype ~= "*"
      and filetype ~= "text"
      and not vim.tbl_contains(ensure_installed, filetype)
    then
      table.insert(ensure_installed, filetype)
    end
  end
end

require("tree-sitter-manager").setup({
  ensure_installed = ensure_installed,
  auto_install = true,
})

local disabled_indent = { "yaml", "bash", "python" }
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local bufnr = event.buf
    if not utils.have(bufnr) then
      return
    end

    if utils.have(bufnr, "folds") then
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end

    local filetype = vim.bo[bufnr].filetype
    if utils.have(bufnr, "indents") and not vim.tbl_contains(disabled_indent, filetype) then
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
  desc = "treesitter folds/indent",
})

require("nvim-treesitter-textobjects").setup({
  select = {
    enable = true,
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v",
      ["@function.outer"] = "V",
      ["@class.outer"] = "<c-v>",
    },
    include_surrounding_whitespace = true,
  },
  move = {
    enable = true,
    set_jumps = true,
    goto_next_start = {
      ["<C-down>"] = "@function.outer",
      ["<C-j>"] = "@function.outer",
    },
    goto_previous_start = {
      ["<C-up>"] = "@function.outer",
      ["<C-k>"] = "@function.outer",
    },
    goto_previous_end = {
      ["<C-K>"] = "@function.outer",
    },
  },
})

vim.keymap.set({ "x", "o" }, "af", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, { silent = true, desc = "select outer function" })

vim.keymap.set({ "x", "o" }, "if", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, { silent = true, desc = "select inner function" })

vim.keymap.set({ "x", "o" }, "ac", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, { silent = true, desc = "select outer class" })

vim.keymap.set({ "x", "o" }, "ic", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, { silent = true, desc = "select inner class" })
