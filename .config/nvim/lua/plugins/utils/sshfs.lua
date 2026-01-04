return {
  "uhs-robert/sshfs.nvim",
  keys = {
    "<leader>mm",
    "<leader>mu",
    "<leader>me",
    "<leader>md",
    "<leader>mo",
    "<leader>mc",
    "<leader>mr",
    "<leader>mf",
    "<leader>mg",
    "<leader>mt",
  },
  command = {
    "SSHConnect",
    "SSHDisconnect",
    "SSHConfig",
    "SSHReload",
    "SSHFiles",
    "SSHGrep",
    "SSHLiveFind",
    "SSHLiveGrep",
    "SSHExpl",
  },
  opts = {
    mounts = {
      base_dir = "/tmp/sshfs", -- where remote mounts are created
    },
    host_paths = {
      ["kirby-server"] = { "/srv" },
    },
    ui = {
      file_picker = {
        preferred_picker = "fzf-lua", -- one of: "auto", "snacks", "fzf-lua", "mini", "telescope", "oil", "neo-tree", "nvim-tree", "yazi", "lf", "nnn", "ranger", "netrw"
        fallback_to_netrw = false, -- fallback to netrw if no picker is available
      },
      live_remote_picker = {
        preferred_picker = "fzf-lua", -- one of: "auto", "snacks", "fzf-lua", "telescope", "mini"
      },
    },
  },
}
