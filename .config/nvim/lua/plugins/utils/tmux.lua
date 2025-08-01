return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<M-Left>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<M-Down>", "<cmd>TmuxNavigateDown<cr>" },
    { "<M-Up>", "<cmd>TmuxNavigateUp<cr>" },
    { "<M-Right>", "<cmd>TmuxNavigateRight<cr>" },
    { "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
    { "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
    { "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
  },
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
}

-- return {
-- 	"aserowy/tmux.nvim",
-- 	event = "VeryLazy",
-- 	cond = function()
-- 		return os.getenv("TMUX") ~= nil
-- 	end,
-- 	opts = {
-- 		copy_sync = {
-- 			-- enables copy sync. by default, all registers are synchronized.
-- 			-- to control which registers are synced, see the `sync_*` options.
-- 			enable = false,
--
-- 			-- ignore specific tmux buffers e.g. buffer0 = true to ignore the
-- 			-- first buffer or named_buffer_name = true to ignore a named tmux
-- 			-- buffer with name named_buffer_name :)
-- 			ignore_buffers = { empty = false },
--
-- 			-- TMUX >= 3.2: all yanks (and deletes) will get redirected to system
-- 			-- clipboard by tmux
-- 			redirect_to_clipboard = true,
--
-- 			-- offset controls where register sync starts
-- 			-- e.g. offset 2 lets registers 0 and 1 untouched
-- 			register_offset = 0,
--
-- 			-- overwrites vim.g.clipboard to redirect * and + to the system
-- 			-- clipboard using tmux. If you sync your system clipboard without tmux,
-- 			-- disable this option!
-- 			sync_clipboard = true,
--
-- 			-- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
-- 			sync_registers = false,
--
-- 			-- syncs deletes with tmux clipboard as well, it is advised to
-- 			-- do so. Nvim does not allow syncing registers 0 and 1 without
-- 			-- overwriting the unnamed register. Thus, ddp would not be possible.
-- 			sync_deletes = true,
--
-- 			-- syncs the unnamed register with the first buffer entry from tmux.
-- 			sync_unnamed = true,
-- 		},
-- 		navigation = {
-- 			-- cycles to opposite pane while navigating into the border
-- 			cycle_navigation = true,
--
-- 			-- enables default keybindings (C-hjkl) for normal mode
-- 			enable_default_keybindings = false,
--
-- 			-- prevents unzoom tmux when navigating beyond vim border
-- 			persist_zoom = false,
-- 		},
-- 		resize = {
-- 			-- enables default keybindings (A-hjkl) for normal mode
-- 			enable_default_keybindings = false,
-- 		},
-- 	},
-- }
