local tiny_diags_disabled_by_nes = false

return {
  {
    "folke/sidekick.nvim",
    enabled = true,
    lazy = true,
    opts = {
      nes = {
        enabled = true,
      },
      mux = {
        backend = "tmux",
        enabled = true,
      },
      cli = {
        win = {
          keys = {
            stopinsert = { "<esc>", "stopinsert", mode = "t" }, -- enter normal mode
            win_p = { "<M-Left>", "blur" },
          },
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end,
        mode = { "n", "v" },
        desc = "Sidekick Toggle CLI",
      },
    },
    config = function(_, opts)
      require("sidekick").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "SidekickNesHide",
        callback = function()
          if tiny_diags_disabled_by_nes then
            tiny_diags_disabled_by_nes = false
            require("tiny-inline-diagnostic").enable()
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "SidekickNesShow",
        callback = function()
          tiny_diags_disabled_by_nes = true
          require("tiny-inline-diagnostic").disable()
        end,
      })
    end,
  },
}
