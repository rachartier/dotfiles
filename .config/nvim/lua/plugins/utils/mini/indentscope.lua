local M = {}

M.disabled_filetypes = {
  "help",
  "alpha",
  "dashboard",
  "ministarter",
  "neo-tree",
  "Trouble",
  "trouble",
  "lazy",
  "mason",
  "notify",
  "toggleterm",
  "dapui_stacks",
  "lazyterm",
  "fzf",
  "spectre_panel",
  "snacks_dashboard",
  "snacks_notif",
  "snacks_terminal",
  "snacks_win",
}

function M.setup()
  require("mini.indentscope").setup({
    draw = {
      delay = 0,
      animation = require("mini.indentscope").gen_animation.none(),
    },
    options = {
      indent_at_cursor = true,
      try_as_border = true,
      border = "top",
    },
  })
end

return M
