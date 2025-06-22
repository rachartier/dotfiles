return {
  "ravitemer/mcphub.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "bundled_build.lua",
  config = function()
    require("mcphub").setup({
      use_bundled_binary = true, -- Use local `mcp-hub` binary
    })
  end,
}
