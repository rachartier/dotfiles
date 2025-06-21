return {
  "axelvc/template-string.nvim",
  event = "VeryLazy",
  config = function()
    require("template-string").setup()
  end,
}
