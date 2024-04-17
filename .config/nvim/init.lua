vim.loader.enable()
vim.g.mapleader = " "

local icons = require("config.icons")

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
require("lazy").setup("plugins", {
	ui = {
		border = icons.default_border,
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		frequency = 3600, -- check for updates every hour
		notify = false,
	},
	rtp = {
		disabled_plugins = {
			"2html_plugin",
			"tohtml",
			"getscript",
			"getscriptPlugin",
			"gzip",
			"logipat",
			"netrw",
			"netrwPlugin",
			"netrwSettings",
			"netrwFileHandlers",
			"matchit",
			"tar",
			"tarPlugin",
			"rrhelper",
			"spellfile_plugin",
			"vimball",
			"vimballPlugin",
			"zip",
			"zipPlugin",
			"tutor",
			"rplugin",
			"syntax",
			"synmenu",
			"optwin",
			"compiler",
			"bugreport",
			"ftplugin",
		},
	},
})

require("set")
require("neovide")

require("remap")
require("autocmds")

-- require("user_plugins.switchbuffer").setup({})
require("user_plugins.auto_interpo_string").setup()

require("theme").setup()

require("config.diagnostic")
