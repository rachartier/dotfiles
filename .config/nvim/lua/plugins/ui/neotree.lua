local M = {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>te", "<cmd>Neotree float %:p<CR>" },
	},
	priority = 55,
}

function M.config()
	local U = require("utils")

	require("lsp-file-operations").setup()

	require("neo-tree").setup({
		close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
		popup_border_style = U.default_border,
		enable_git_status = true,
		enable_diagnostics = true,
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1, -- extra padding on left hand side
				-- indent guides
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				highlight = "NeoTreeIndentMarker",
				-- expander config, needed for nesting files
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "ﰊ",
				-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
				-- then these will never be used.
				default = "*",
				highlight = "NeoTreeFileIcon",
			},
			modified = {
				symbol = U.signs.file.modified,
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					untracked = "",
					ignored = " ",
					unstaged = "󰄱 ",
					staged = " ",
					added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
					modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
					renamed = "", -- this can only be used in the git_status source
					conflict = "",
					unmerged = "",
					deleted = U.git_signs.removed,
				},
			},
			file_size = {
				enabled = true,
				required_width = 64, -- min width of window required to show this column
			},
			type = {
				enabled = false,
				required_width = 122, -- min width of window required to show this column
			},
			last_modified = {
				enabled = true,
				required_width = 64, --88, -- min width of window required to show this column
			},
			created = {
				enabled = false,
				required_width = 110, -- min width of window required to show this column
			},
		},

		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
			},
		},
	})
end

return {
	{
		"antosha417/nvim-lsp-file-operations",
		priority = 50,
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	M,
}
