return {
  "dmtrKovalenko/fff.nvim",
  enabled = false,
  build = "cargo build --release",
  opts = {
    -- pass here all the options
    prompt = " ",
    layout = {
      height = vim.g.float_height,
      width = vim.g.float_width,
      preview_position = "right",
    },
  },
  keys = {
    {
      "<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
      function()
        require("fff").find_files()
      end,
      desc = "Toggle FFF",
    },
  },
  config = function(_, opts)
    require("fff").setup(opts)
  end,
}
