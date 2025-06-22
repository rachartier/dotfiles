return {
  "echasnovski/mini.icons",
  version = "*",
  opts = {
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
  },
  lazy = true,
  specs = {
    { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  -- "nvim-tree/nvim-web-devicons",
  -- enabled = true,
}
