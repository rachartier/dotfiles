vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy_utils").setup()

require("lazy").setup("plugins", {
	ui = {
		border = "rounded",
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		frequency = 3600, -- check for updates every hour
		notify = false,
	},
	performance = {
		cache = {
			enabled = true,
		},

		rtp = {
			disabled_plugins = {
				reset = true,
				disabled_plugins = {
					"startify",
					"gzip",
					"matchit",
					"matchparen",
					"netrwPlugin",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
					"man",
					"osc52",
					"spellfile",
				},
			},
		},
	},
})

require("set")
require("neovide")

vim.defer_fn(function()
	require("remap")
end, 50)

require("autocmds")
