local M = {}

function M.setup()
  require("mini.icons").setup({
    file = {
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      json = { glyph = "" },
      jsonc = { glyph = "" },
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
    extension = {
      conf = { glyph = "", hl = "MiniIconsBlue" },
    },
  })
end

return M
