return {
	"vimwiki/vimwiki",
	dependencies = {
		"michal-h21/vimwiki-sync",
	},
	keys = {
		"<leader>ww",
		"<leader>wt",
		"<leader>ws",
		"<leader>wi",
		"<leader>wI",
		"<leader>wr",
	},
	init = function()
		vim.g.vimwiki_list = {
			{
				path = "~/.config/nvim/notes/",
				syntax = "markdown",
				ext = ".md",
			},
		}

		vim.g.vimwiki_global_ext = 1
		vim.g.vimwiki_use_mouse = 1

		require("utils").on_event("FileType", function()
			vim.o.filetype = "markdown"
		end, {
			target = "vimwiki",
		})
	end,
}
