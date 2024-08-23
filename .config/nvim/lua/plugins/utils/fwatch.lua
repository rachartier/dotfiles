return {
	"rktjmp/fwatch.nvim",
	event = "VeryLazy",
	enabled = require("config").config_type ~= "minimal",
	config = function()
		local ok, fwatch = pcall(require, "fwatch")

		if ok then
			fwatch.watch("/tmp/tmux-theme.cache", {
				on_event = function()
					vim.schedule(function()
						require("theme").setup()
						-- require("tiny-devicons-auto-colors").apply(M._theme.get_colors())
						local plugin = require("lazy.core.config").plugins["lualine.nvim"]
						require("lazy.core.loader").reload(plugin)
						require("lualine").refresh()
					end)
				end,
			})
		end
	end,
}
