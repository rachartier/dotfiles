vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
}, { confirm = false, load = false })

local utils = require("utils")

local disabled_indent = { "yaml", "bash", "python" }

local function start_treesitter(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ok = pcall(vim.treesitter.start, bufnr)

  if not ok then
    return
  end

  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  if utils.have(filetype, "folds") then
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end

  if utils.have(filetype, "indents") and not vim.tbl_contains(disabled_indent, filetype) then
    vim.bo[bufnr].indentexpr = "v:lua.require'utils'.indentexpr()"
  end
end

local function attach_treesitter(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  local parser_name = vim.treesitter.language.get_lang(filetype)
  if not parser_name then
    return
  end

  if not utils.have(filetype) then
    require("nvim-treesitter").install({ parser_name }):await(function()
      start_treesitter(bufnr)
    end)
    return
  end

  start_treesitter(bufnr)
end

local function setup_treesitter_autocmd()
  local parsers = require("nvim-treesitter").get_available()

  if not parsers or #parsers == 0 then
    return
  end

  local ft_to_attach = {}
  for _, parser in ipairs(parsers) do
    local filetypes = vim.treesitter.language.get_filetypes(parser)

    if filetypes and #filetypes > 0 then
      for _, ft in ipairs(filetypes) do
        if not vim.tbl_contains(ft_to_attach, ft) then
          table.insert(ft_to_attach, ft)
        end
      end
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft_to_attach,
    callback = function(event)
      attach_treesitter(event.buf)
    end,
    desc = "start treesitter for filetype",
  })
end

local function load_treesitter()
  setup_treesitter_autocmd()

  local lang_config = require("config.languages")
  local ensure_installed = { "regex", "bash" }

  for _, lang in ipairs(lang_config) do
    if lang.treesitter then
      for _, parser_name in ipairs(lang.treesitter) do
        if not vim.tbl_contains(ensure_installed, parser_name) then
          table.insert(ensure_installed, parser_name)
        end
      end
    else
      for _, filetype in ipairs(lang.filetypes or {}) do
        if filetype ~= "*" and filetype ~= "text" then
          local parser_name = vim.treesitter.language.get_lang(filetype)
          if parser_name and not vim.tbl_contains(ensure_installed, parser_name) then
            table.insert(ensure_installed, parser_name)
          end
        end
      end
    end
  end

  local already_installed = require("nvim-treesitter").get_installed()
  local parsers_to_install = {}

  for _, parser in ipairs(ensure_installed) do
    if not vim.tbl_contains(already_installed, parser) then
      table.insert(parsers_to_install, parser)
    end
  end

  if #parsers_to_install > 0 then
    require("nvim-treesitter").install(parsers_to_install)
  end

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
  })

  for _, key in ipairs({ "<C-down>", "<C-j>" }) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    end, { silent = true, desc = "next function start" })
  end

  for _, key in ipairs({ "<C-up>", "<C-k>" }) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
    end, { silent = true, desc = "previous function start" })
  end

  vim.keymap.set({ "n", "x", "o" }, "<C-K>", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
  end, { silent = true, desc = "previous function end" })

  vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject(
      "@function.outer",
      "textobjects"
    )
  end, { silent = true, desc = "select outer function" })

  vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject(
      "@function.inner",
      "textobjects"
    )
  end, { silent = true, desc = "select inner function" })

  vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
  end, { silent = true, desc = "select outer class" })

  vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
  end, { silent = true, desc = "select inner class" })
end

local group = vim.api.nvim_create_augroup("lazy_treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" then
      return
    end
    vim.api.nvim_del_augroup_by_id(group)

    vim.cmd.packadd("nvim-treesitter")
    vim.cmd.packadd("nvim-treesitter-textobjects")
    load_treesitter()

    attach_treesitter(ev.buf)
  end,
  desc = "lazy-load treesitter on first real file",
})
