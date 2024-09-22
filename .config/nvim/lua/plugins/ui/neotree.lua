local signs = require("config.icons").signs

return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
	keys = {
		{ "<leader>te", "<cmd>Neotree float %:p<CR>", desc = "Toggle NeoTree" },
	},
	opts = {
		close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
		default_component_configs = {
			container = {
				enable_character_fade = false,
			},
			indent = {
				indent_size = 2,
				-- padding = 1, -- extra padding on left hand side
				-- indent guides
				with_markers = true,
			},
			-- icon = {
			-- 	folder_closed = "󰉋",
			-- 	folder_open = "󰝰",
			-- 	folder_empty = "󰉖",
			-- },
			modified = {
				symbol = signs.file.modified,
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					untracked = signs.git.untracked,
					ignored = signs.git.ignored,
					unstaged = signs.git.unstaged,
					staged = signs.git.staged,
					added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
					modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
					renamed = signs.git.renamed, -- this can only be used in the git_status source
					conflict = signs.git.branch,
					unmerged = signs.git.branch,
					deleted = signs.git.removed,
				},
			},
			file_size = {
				enabled = true,
				required_width = 64, -- min width of window required to show this column
			},
			type = {
				enabled = false,
			},
			last_modified = {
				enabled = true,
				required_width = 64, --88, -- min width of window required to show this column
			},
			created = {
				enabled = false,
			},
		},
		filesystem = {
			use_libuv_file_watcher = true,
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
			},
		},
	},
}
