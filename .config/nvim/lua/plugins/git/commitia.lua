return {
	"rhysd/committia.vim",
	lazy = true,
	ft = { "gitcommit", "gitrebase" },
	config = function()
		vim.g.committia_default_commit_message_filetype = "markdown"
	end,
}
