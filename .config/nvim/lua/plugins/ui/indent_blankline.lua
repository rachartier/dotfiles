local M = {
	-- "lukas-reineke/indent-blankline.nvim",
	-- main = "ibl",

	"echasnovski/mini.indentscope",
	event = { "BufReadPre", "BufNewFile" },
	enabled = false,
}

function M.init()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"help",
			"alpha",
			"dashboard",
			"neo-tree",
			"Trouble",
			"lazy",
			"mason",
			"notify",
			"toggleterm",
			"dapui_stacks",
		},
		callback = function()
			vim.b.miniindentscope_disable = true
		end,
	})
end

function M.config()
	-- require("indent_blankline").setup({
	--     char = "",
	--     show_current_context = false,
	--     show_current_context_start = false,
	--     show_trailing_blankline_indent = false,
	--     -- space_char_blankline = " ",
	--     max_indent_increase = 1,
	-- })
	-- vim.g.indent_blankline_use_treesitter = false
	-- vim.g.indent_blankline_show_trailing_blankline_indent = false

	-- require("ibl").setup()
	require("mini.indentscope").setup({
		draw = {
			delay = 0,
			animation = require("mini.indentscope").gen_animation.none(),
		},
		options = {
			indent_at_cursor = true,
			try_as_border = true,
			border = "top",
		},
		symbol = "╎",
	})
end

return M
