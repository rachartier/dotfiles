return {
  "nvim-mini/mini.nvim",
  version = false,
  event = { "VeryLazy" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "dapui_stacks",
        "toggleterm",
        "lazyterm",
        "fzf",
        "spectre_panel",
        "snacks_dashoard",
        "snacks_notif",
        "snacks_terminal",
        "snacks_win",
      },
      callback = function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.miniindentscope_disable = true
      end,
      desc = "Disable mini.indentscope",
    })
  end,
  config = function()
    require("mini.splitjoin").setup({
      mappings = {
        toggle = "gS",
        split = "",
        join = "",
      },
    })
    require("mini.surround").setup()
    require("mini.align").setup()
    -- require("mini.indentscope").setup({
    --     draw = {
    --       delay = 0,
    --       animation = require("mini.indentscope").gen_animation.none(),
    --     },
    --     options = {
    --       indent_at_cursor = true,
    --       try_as_border = true,
    --       border = "top",
    --     },
    --     symbol = "┆",
    -- })

    local ai = require("mini.ai")
    require("mini.ai").setup({
      {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      },
    })
  end,
}
