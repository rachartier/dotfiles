return {
  {
    "folke/sidekick.nvim",
    enabled = true,
    opts = {
      nes = {
        enabled = false,
      },
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end,
        desc = "Sidekick Toggle CLI",
      },
    },
  },
}
