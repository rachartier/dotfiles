return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "saghen/blink.cmp",
    },
    event = "LazyFile",
    keys = {
      {
        "<leader>c",
        function()
          require("copilot.panel").toggle()
        end,
      },
      {
        "<leader>cn",
        function()
          require("copilot.panel").jump_next()
        end,
      },
      {
        "<leader>cp",
        function()
          require("copilot.panel").jump_prev()
        end,
      },
    },
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = false,
          },
        },
        panel = { enabled = true },
        filetypes = {
          sh = function()
            local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
            if
              string.match(filename, "^%.env.*")
              or string.match(filename, "^%.secret.*")
              or string.match(filename, "^%id_rsa.*")
            then
              return false
            end

            return true
          end,
          ["copilot-chat"] = true,
          ["*"] = true,
          ["."] = true,
          markdown = true,
        },
        copilot_model = "gpt-4o-copilot",
        server = {
          type = "binary", -- "nodejs" | "binary"
          custom_server_filepath = nil,
        },
      })

      vim.keymap.set("i", "<tab>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
          return "<Ignore>"
        end
        return "<tab>"
      end, { expr = true, noremap = true })
    end,
  },
}
