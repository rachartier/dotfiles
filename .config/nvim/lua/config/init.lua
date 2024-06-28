local M = {}

if vim.g.neovide then
    M.pumblend = 25 -- Popup blend
    M.winblend = 45 -- Window blend
else
    M.pumblend = 0
    M.winblend = 0
end

M.gif_alpha_enabled = false
M.tty_clock_alpha_enabled = true

M.config_type = "normal"

if os.getenv("DOTFILES_MINIMAL") then
    M.config_type = "minimal"
end

return M
