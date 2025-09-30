return {
  {
    "folke/sidekick.nvim",
    enabled = true,
    opts = {
      nes = {
        enabled = false,
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick Toggle CLI",
      },
    },
  },
}
