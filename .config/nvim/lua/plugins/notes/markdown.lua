return {
	{
		enabled = true,
		"MeanderingProgrammer/markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		name = "render-markdown",
		ft = { "markdown", "pandoc", "avante" },
		cond = require("config").config_type ~= "minimal",
		opts = {
			bullet = {
				icons = { "", "", "◆", "◇" },
			},
			heading = {
				icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
				left_pad = 1,
				border = false,
				border_prefix = true,
			},
			checkbox = {
				unchecked = {
					icon = "󰄱 ",
					highlight = "RenderMarkdownUnchecked",
				},
				checked = {
					icon = "󰄲 ",
					highlight = "RenderMarkdownChecked",
				},
				custom = {
					todo = { raw = "[-]", rendered = "󰡖 ", highlight = "RenderMarkdownListTodo" },
					skipped = { raw = "[/]", rendered = "󱋭 ", highlight = "RenderMarkdownListSkipped" },
					fire = { raw = "[f]", rendered = "󰈸 ", highlight = "RenderMarkdownListFire" },
					star = { raw = "[s]", rendered = " ", highlight = "RenderMarkdownListStar" },
					idea = { raw = "[*]", rendered = "󰌵 ", highlight = "RenderMarkdownListIdea" },
					yes = { raw = "[y]", rendered = "󰔓 ", highlight = "RenderMarkdownListYes" },
					no = { raw = "[n]", rendered = "󰔑 ", highlight = "RenderMarkdownListNo" },
					question = { raw = "[?]", rendered = " ", highlight = "RenderMarkdownListQuestion" },
					info = { raw = "[i]", rendered = " ", highlight = "RenderMarkdownListInfo" },
					important = { raw = "[!]", rendered = "󱅶 ", highlight = "RenderMarkdownListImportant" },
				},
			},
			file_types = { "markdown", "pandoc", "Avante" },
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)

			local function toggle_checkbox(char)
				local current_line = vim.api.nvim_get_current_line()

				local _, _, checkbox_state = string.find(current_line, "%[([ " .. char .. string.upper(char) .. "])%]")

				if checkbox_state then
					local new_state = checkbox_state == " " and char or " "
					local new_line = string.gsub(current_line, "%[.-%]", "[" .. new_state .. "]")

					vim.api.nvim_set_current_line(new_line)
				end
			end
			vim.keymap.set("n", "<Leader>x", function()
				toggle_checkbox("x")
			end, { noremap = true, silent = true })

			vim.keymap.set("n", "<Leader>X", function()
				toggle_checkbox("o")
			end, { noremap = true, silent = true })
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
