return {
	-- {
	-- 	enabled = true,
	-- 	"MeanderingProgrammer/markdown.nvim",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	name = "render-markdown",
	-- 	ft = { "markdown", "pandoc", "Avante" },
	-- 	cond = require("config").config_type ~= "minimal",
	-- 	opts = {
	-- 		bullet = {
	-- 			icons = { "", "", "◆", "◇" },
	-- 		},
	-- 		heading = {
	-- 			icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
	-- 			left_pad = 1,
	-- 			border = false,
	-- 			border_prefix = true,
	-- 		},
	-- 		checkbox = {
	-- 			position = "inline",
	-- 			unchecked = {
	-- 				icon = " ",
	-- 				highlight = "RenderMarkdownUnchecked",
	-- 			},
	-- 			checked = {
	-- 				icon = " ",
	-- 				highlight = "RenderMarkdownChecked",
	-- 			},
	-- 			custom = {
	-- 				pending = { raw = "[-]", rendered = " ", highlight = "MarkdownCheckboxPending" },
	-- 				todo = { raw = "[~]", rendered = " ", highlight = "MarkdownCheckboxTodo" },
	-- 				skipped = { raw = "[/]", rendered = " ", highlight = "MarkdownCheckboxSkipped" },
	-- 				fire = { raw = "[f]", rendered = "󰈸 ", highlight = "MarkdownCheckboxFire" },
	-- 				star = { raw = "[s]", rendered = " ", highlight = "MarkdownCheckboxStar" },
	-- 				idea = { raw = "[*]", rendered = "󰌵 ", highlight = "MarkdownCheckboxIdea" },
	-- 				yes = { raw = "[y]", rendered = "󰔓 ", highlight = "MarkdownCheckboxYes" },
	-- 				no = { raw = "[n]", rendered = "󰔑 ", highlight = "MarkdownCheckboxNo" },
	-- 				question = { raw = "[?]", rendered = " ", highlight = "MarkdownCheckboxQuestion" },
	-- 				info = { raw = "[i]", rendered = " ", highlight = "MarkdownCheckboxInfo" },
	-- 				important = { raw = "[!]", rendered = "󱅶 ", highlight = "MarkdownCheckboxImportant" },
	-- 			},
	-- 		},
	-- 		file_types = { "markdown", "pandoc", "Avante" },
	-- 	},
	-- },
	{
		"OXY2DEV/markview.nvim",
		ft = "markdown",
		config = function()
			local presets = require("markview.presets")

			local checkbox = presets.checkboxes.nerd

			checkbox.custom = vim.tbl_extend("force", checkbox.custom, {
				{ match_string = "-", text = "", hl = "MarkviewCheckboxPending" },
				{ match_string = "~", text = "", hl = "MarkviewCheckboxProgress" },
				{ match_string = "/", text = " ", hl = "MarkdownCheckboxSkipped" },
				{ match_string = "f", text = "󰈸 ", hl = "MarkdownCheckboxFire" },
				{ match_string = "s", text = " ", hl = "MarkdownCheckboxStar" },
				{ match_string = "*", text = "󰌵 ", hl = "MarkdownCheckboxIdea" },
				{ match_string = "y", text = "󰔓 ", hl = "MarkdownCheckboxYes" },
				{ match_string = "n", text = "󰔑 ", hl = "MarkdownCheckboxNo" },
				{ match_string = "?", text = " ", hl = "MarkdownCheckboxQuestion" },
				{ match_string = "i", text = " ", hl = "MarkdownCheckboxInfo" },
				{ match_string = "!", text = "󱅶 ", hl = "MarkdownCheckboxImportant" },
			})

			require("markview").setup({
				modes = { "n", "i", "v", "V", "c", "nc" },
				hybrid_modes = { "i" },

				filetypes = { "markdown", "quarto", "rmd", "Avante" },
				checkboxes = checkbox,
				headings = presets.headings.decorated,
				code_blocks = {
					style = "language",
					icons = "mini",

					language_direction = "right",
					min_width = 60,
					pad_char = " ",
					pad_amount = 3,

					language_names = {
						["txt"] = "Text",
					},

					hl = "MarkviewCode",
					info_hl = "MarkviewCodeInfo",

					sign = true,
					sign_hl = nil,
				},
				horizontal_rules = presets.horizontal_rules.thin,
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
