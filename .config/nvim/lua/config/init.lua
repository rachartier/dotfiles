local M = {}

if vim.g.neovide then
	M.pumblend = 25 -- Popup blend
	M.winblend = 40 -- Window blend
else
	M.pumblend = 0
	M.winblend = 0
end

M.gif_alpha_enabled = false
M.tty_clock_alpha_enabled = true

vim.g.dotfile_config_type = "normal"
vim.g.path_dotfiles = vim.env.HOME .. "/.config"
vim.g.path_dev = vim.env.HOME .. "/dev"
vim.g.dev_ws = "/workspaces"

if os.getenv("DOTFILES_MINIMAL") then
	vim.g.dotfile_config_type = "minimal"
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.filetype.add({
	extension = {
		["http"] = "http",
		["p8"] = "pico8",
		["dotfile_profile"] = "bash",
		["profile"] = "bash",
		["tcss"] = "css",
		["xaml"] = "xml",
	},
	filename = {
		["vifmrc"] = "vim",
	},
	pattern = {
		[".*/waybar/config"] = "jsonc",
		[".*/mako/config"] = "dosini",
		[".*/kitty/.+%.conf"] = "kitty",
		[".*/hypr/.+%.conf"] = "hyprlang",
		["%.env%.[%w_.-]+"] = "sh",
	},
})

vim.treesitter.language.register("sh", "bash")

vim.g.noncode_ft = {
	"text",
	"help",
	"gitcommit",
	"gitrebase",
	"svn",
	"diff",
	"markdown",
	"txt",
	"plaintext",
	"jsonc",
}

vim.g.catppuccin_flavour = "macchiato"

return M
