return {
	"jake-stewart/multicursor.nvim",
	keys = {
		{
			mode = { "n", "v" },
			"<C-up>",
			"<cmd>lua require('multicursor-nvim').addCursor('k')<CR>",
		},
		{
			mode = { "n", "v" },
			"<C-down>",
			"<cmd>lua require('multicursor-nvim').addCursor('j')<CR>",
		},
		{
			mode = { "n", "v" },
			"<C-left>",
			"<cmd>lua require('multicursor-nvim').addCursor('h')<CR>",
		},
		{
			mode = { "n", "v" },
			"<C-right>",
			"<cmd>lua require('multicursor-nvim').addCursor('l')<CR>",
		},
		{
			mode = { "n", "v" },
			"<leader>mn",
			"<cmd>lua require('multicursor-nvim').nextCursor<CR>",
		},
		{
			mode = { "n", "v" },
			"<leader>mp",
			"<cmd>lua require('multicursor-nvim').prevCursor<CR>",
		},
		{
			mode = { "n", "v" },
			"<leader>mm",
			"<cmd>lua require('multicursor-nvim').addCursor('*')<CR>",
			-- function()
			-- 	local mc = require("multicursor-nvim")
			--
			-- 	mc.action(function(ctx)
			-- 		local has_cursor = ctx:hasCursors()
			--
			-- 		if has_cursor then
			-- 			mc.addCursor("*")
			-- 		end
			-- 	end)
			-- 	return require("multicursor-nvim").is_active()
			-- end,
		},
		{
			mode = { "n", "v" },
			"<esc>",
			function()
				local mc = require("multicursor-nvim")

				if not mc.cursorsEnabled() then
					mc.enableCursors()
				elseif mc.hasCursors() then
					mc.clearCursors()
				else
					-- Default <esc> handler.
				end
			end,
		},
		{
			mode = { "n", "v" },
			"<leader>ma",
			"<cmd>lua require('multicursor-nvim').alignCurosrs<CR>",
		},
	},
	config = function(_, opts)
		require("multicursor-nvim").setup(opts)
	end,
}
