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
}
