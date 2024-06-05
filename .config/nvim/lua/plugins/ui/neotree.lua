return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = { "<leader>te" },
		config = function()
			local U = require("utils")
			local icons = require("config.icons")

			require("lsp-file-operations").setup()

			local function on_move(data)
				U.on_rename(data.source, data.destination)
			end

			local opts = {
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
						folder_closed = "󰉋",
						folder_open = "󰝰",
						folder_empty = "󰉖",
						-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
						-- then these will never be used.
						default = "*",
						highlight = "NeoTreeFileIcon",
					},
					modified = {
						symbol = icons.signs.file.modified,
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
							renamed = "󰑕", -- this can only be used in the git_status source
							conflict = "",
							unmerged = "",
							deleted = icons.signs.git.removed,
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
					use_libuv_file_watcher = true,
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
				},
			}

			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})

			require("neo-tree").setup(opts)

			vim.keymap.set("n", "<leader>te", "<cmd>Neotree float %:p<CR>")
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		config = function()
			require("lsp-file-operations").setup()
		end,
		keys = { "<leader>te" },
	},
}
