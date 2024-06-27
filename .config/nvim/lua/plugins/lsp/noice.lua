return {

	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"j-hui/fidget.nvim",
		},
		event = "VeryLazy",
		enabled = true,
		opts = {
			cmdline = {
				-- view = "cmdline",
				format = {
					cmdline = { title = "", pattern = "^:", icon = "", lang = "vim" },
					search_down = { title = "", kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { title = "", kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { title = "", pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = {
						title = "",
						pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
						icon = " ",
						lang = "lua",
					},
					help = { title = "", pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
					input = {},
				},
			},
			messages = {
				-- NOTE: If you enable messages, then the cmdline is enabled automatically.
				-- This is a current Neovim limitation.
				enabled = true, -- enables the Noice messages UI
				view = "notify", -- default view for messages
				view_error = "notify", -- view for errors
				view_warn = "notify", -- view for warnings
				view_history = "messages", -- view for :messages
				view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
			},
			views = {
				cmdline_popup = {
					border = {
						style = require("config.icons").default_border,
					},
				},
			},
			lsp = {
				progress = {
					enabled = true,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			hover = {
				enabled = true,
				silent = false, -- set to true to not show a message if hover is not available
				view = nil, -- when nil, use defaults from documentation
				opts = {}, -- merged with defaults from documentation
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
		},
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				{ noremap = true, silent = true, desc = "Dismiss all Notifications" },
			},
		},
	},
}
