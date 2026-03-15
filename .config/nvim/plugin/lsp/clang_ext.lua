vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "h", "hpp", "hh", "hxx" },
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/p00f/clangd_extensions.nvim" }, { confirm = false })

    require("clangd_extensions").setup({
      inlay_hints = {
        inline              = false,
        only_current_line   = false,
        show_parameter_hints = false,
        parameter_hints_prefix = "<- ",
        other_hints_prefix  = "=> ",
        max_len_align        = false,
        max_len_align_padding = 1,
        right_align          = false,
        right_align_padding  = 7,
        highlight            = "Comment",
        priority             = 100,
      },
      ast = {
        role_icons = {
          type        = "",
          declaration = "",
          expression  = "",
          specifier   = "",
          statement   = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound            = "",
          Recovery            = "",
          TranslationUnit     = "",
          PackExpansion       = "",
          TemplateTypeParm    = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        highlights = { detail = "Comment" },
      },
      memory_usage = { border = require("config.ui.border").default_border },
      symbol_info  = { border = require("config.ui.border").default_border },
    })
  end,
})
