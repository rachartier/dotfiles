return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    disable_filetype = {
      "TelescopePrompt",
      "spectre_panel",
      "copilot-chat",
    },
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)
    local Rule = require("nvim-autopairs.rule")

    -- Auto add 'f' prefix when typing '{' inside a string in Python
    npairs.add_rules({
      Rule("f", "{", "python")
        :with_pair(function(opts)
          local next_char = opts.line:sub(opts.col, opts.col)
          return next_char == '"' or next_char == "'"
        end)
        :with_move(function()
          return false
        end)
        :with_cr(function()
          return false
        end)
        :with_del(function()
          return false
        end),
    })

    -- Auto add '$' prefix when typing '{' inside a string in C#
    npairs.add_rules({
      Rule("$", "{", "cs")
        :with_pair(function(opts)
          -- Check if next character is a quote
          local next_char = opts.line:sub(opts.col, opts.col)
          return next_char == '"'
        end)
        :with_move(function()
          return false
        end)
        :with_cr(function()
          return false
        end)
        :with_del(function()
          return false
        end),
    })
  end,
}
