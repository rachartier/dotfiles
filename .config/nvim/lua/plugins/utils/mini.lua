return {
  "nvim-mini/mini.nvim",
  version = false,
  event = { "VeryLazy" },
  specs = {
    { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end

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
    require("mini.surround").setup()
    require("mini.align").setup()

    require("mini.jump2d").setup({})

    require("mini.splitjoin").setup({
      mappings = {
        toggle = "gS",
        split = "",
        join = "",
      },
    })

    local miniclue = require("mini.clue")
    require("mini.clue").setup({
      triggers = {
        -- Leader triggers
        { mode = { "n", "x" }, keys = "<Leader>" },
      },
      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      window = {
        -- Floating window config
        config = {},

        -- Delay before showing clue window
        delay = 100,

        -- Keys to scroll inside the clue window
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
    })

    require("mini.indentscope").setup({
      draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
      options = {
        indent_at_cursor = true,
        try_as_border = true,
        border = "top",
      },
      -- symbol = "┆",
    })

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

    require("mini.icons").setup({
      file = {
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        json = { glyph = "" },
        jsonc = { glyph = "" },
        dotenv = { glyph = "", hl = "MiniIconsYellow" },

        -- sh = { glyph = "󰐣", hl = "MiniIconsBlue" },
        -- zsh = { glyph = "󰐣" },
        -- bash = { glyph = "󰐣" },
      },
      extension = {
        conf = { glyph = "", hl = "MiniIconsBlue" },
      },
    })
  end,
}
