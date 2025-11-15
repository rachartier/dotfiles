local utils = require("utils")

local function start_treesitter(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ok, _ = pcall(vim.treesitter.start, bufnr)

  if not ok then
    return
  end

  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo[bufnr].indentexpr = "v:lua.require'utils'.indentexpr()"
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
      local bufnr = event.buf
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
    end,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    config = function()
      setup_treesitter_autocmd()

      local lang_config = require("config.languages")
      local ensure_installed = {
        "regex",
        "bash",
      }

      for _, lang in ipairs(lang_config) do
        local filetypes = lang.filetypes or {}
        for _, filetype in ipairs(filetypes) do
          if not vim.tbl_contains(ensure_installed, filetype) then
            table.insert(ensure_installed, filetype)
          end
        end
      end

      -- Only install parsers that aren't already installed
      local already_installed = require("nvim-treesitter").get_installed()
      local parsers_to_install = {}

      for _, parser in ipairs(ensure_installed) do
        if not vim.tbl_contains(already_installed, parser) then
          table.insert(parsers_to_install, parser)
        end
      end

      -- Install missing parsers if any
      if #parsers_to_install > 0 then
        require("nvim-treesitter").install(parsers_to_install)
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "LazyFile" },
    keys = {
      {
        "af",
        mode = { "x", "o" },
        function()
          require("nvim-treesitter-textobjects.select").select_textobject(
            "@function.outer",
            "textobjects"
          )
        end,
      },
      {
        "if",
        mode = { "x", "o" },
        function()
          require("nvim-treesitter-textobjects.select").select_textobject(
            "@function.inner",
            "textobjects"
          )
        end,
      },
      {
        "ac",
        mode = { "x", "o" },
        function()
          require("nvim-treesitter-textobjects.select").select_textobject(
            "@class.outer",
            "textobjects"
          )
        end,
      },
      {
        "ic",
        mode = { "x", "o" },
        function()
          require("nvim-treesitter-textobjects.select").select_textobject(
            "@class.inner",
            "textobjects"
          )
        end,
      },
    },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["<C-down>"] = "@function.outer",
            ["<C-j>"] = "@function.outer",
          },
          -- goto_next_end = {
          -- 	["<C-J"] = "@function.outer",
          -- },
          goto_previous_start = {
            ["<C-up>"] = "@function.outer",
            ["<C-k>"] = "@function.outer",
          },
          goto_previous_end = {
            ["<C-K>"] = "@function.outer",
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          -- goto_next = {
          -- 	["]d"] = "@conditional.outer",
          -- },
          -- goto_previous = {
          -- 	["[d"] = "@conditional.outer",
          -- },
        },
      })
    end,
  },
}
