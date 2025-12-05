return {
  "NMAC427/guess-indent.nvim",
  event = "BufReadPre",
  opts = {
    auto_cmd = true,
    override_editorconfig = false,
    filetype_exclude = {
      "netrw",
      "lazy",
      "mason",
    },
    buftype_exclude = {
      "help",
      "terminal",
      "nofile",
    },
  },
}
