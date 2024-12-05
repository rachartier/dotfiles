return {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
	cond = function()
		return os.getenv("TMUX") ~= nil
	end,
	opts = {},
}
