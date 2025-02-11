return {
	{
		"OXY2DEV/markview.nvim",
		enabled = true,
		lazy = true,
		-- branch = "dev",
		ft = { "markdown", "vimwiki" },
		config = function()
			local presets = require("markview.presets")
			local checkbox = presets.checkboxes.nerd

			checkbox.checked = {
				hl = "MarkviewCheckboxChecked",
				text = "",
			}

			checkbox.custom = vim.tbl_extend("force", checkbox.custom, {
				-- { match_string = "/", text = "", hl = "MarkviewCheckboxPending" },
				{ match_string = "/", text = "", hl = "MarkviewCheckboxProgress" },
				{ match_string = "-", text = "", hl = "MarkdownCheckboxSkipped" },
				{ match_string = "f", text = "󰈸", hl = "MarkdownCheckboxFire" },
				{ match_string = "s", text = "", hl = "MarkdownCheckboxStar" },
				{ match_string = "*", text = "󰌵", hl = "MarkdownCheckboxIdea" },
				{ match_string = "y", text = "󰔓", hl = "MarkdownCheckboxYes" },
				{ match_string = "n", text = "󰔑", hl = "MarkdownCheckboxNo" },
				{ match_string = "?", text = "", hl = "MarkdownCheckboxQuestion" },
				{ match_string = "i", text = "", hl = "MarkdownCheckboxInfo" },
				{ match_string = "!", text = "󱅶", hl = "MarkdownCheckboxImportant" },
			})

			require("markview").setup({
				preview = {
					filetypes = { "markdown", "quarto", "rmd", "Avante" },
					hybrid_modes = { "i" },
					modes = { "i", "n", "no", "c" },
				},

				checkboxes = checkbox,
				headings = presets.headings.decorated,
				markdown = {
					horizontal_rules = presets.horizontal_rules.thin,
					-- list_items = {
					-- 	shift_width = 2,
					-- },
				},
				yaml = {
					enable = false,
				},
				code_blocks = {
					style = "language",
					icons = "mini",

					language_direction = "right",
					min_width = 60,
					pad_char = " ",
					pad_amount = 3,

					border_hl = "MarkviewCode",
					info_hl = "MarkviewCodeInfo",

					sign = true,
					sign_hl = nil,
				},
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
		enabled = true,
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = "markdown",
		config = function()
			vim.g.table_mode_corner = "|"
		end,
		enabled = true,
	},
}
