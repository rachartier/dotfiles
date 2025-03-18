return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		"brenoprata10/nvim-highlight-colors",
	},
	-- build = "cargo build --release",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		keymap = { preset = "super-tab" },

		enabled = function()
			return not vim.tbl_contains({
				"Avante",
				"copilot-chat",
			}, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
		end,

		completion = {
			ghost_text = {
				enabled = false,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			documentation = {
				-- border = "padded",
				-- border = require("config.ui.border").blink_empty,
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			menu = {
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
						if vim.fn.mode() == "c" and vim.fn.getcmdtype() == "/" then
							return { pos[1] - 1, pos[2] }
						end
						return { pos[1], pos[2] }
					end

					return { vim.o.lines + 1, 0 }
				end,
				draw = {
					treesitter = { "lsp" },
				},
			},
			trigger = {
				show_on_insert_on_trigger_character = false,
			},
		},

		sources = {
			default = {
				"copilot",
				"lsp",
				"path",
				"snippets",
				"buffer",
				"lazydev",
			},
			providers = {
				-- dont show LuaLS require statements when lazydev has items
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
					opts = {
						max_completions = 3,
						max_attempts = 4,
					},
				},
			},
		},

		appearance = {
			kind_icons = require("config.ui.kinds"),
		},
	},
	config = function(_, opts)
		require("blink-cmp").setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				require("copilot.suggestion").dismiss()
				vim.b.copilot_suggestion_hidden = true
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			callback = function()
				vim.b.copilot_suggestion_hidden = false
			end,
		})
	end,
}
