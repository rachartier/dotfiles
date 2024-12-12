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
	config = function()
		vim.g.vimwiki_key_mappings = {
			table_mappings = 0,
		}

		vim.keymap.set("n", "<leader>nl", "<Plug>VimwikiNextLink", { silent = true }) -- For Tab
		vim.keymap.set("n", "<leader>pl", "<Plug>VimwikiPrevLink", { silent = true }) -- For STab
	end,
}
