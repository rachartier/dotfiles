return {
  "akinsho/git-conflict.nvim",
  event = "LazyFile",
  opts = {
    disable_diagnostics = true,
    default_mappings = {
      ours = "o",
      theirs = "t",
      none = "0",
      both = "b",
      next = "n",
      prev = "p",
    },
  },
}
