if vim.g.neovide then
	-- vim.o.guifont = "CaskaydiaCove NF, Symbols Nerd Font"
	-- vim.o.guifont = "Cascadia Code,Symbols Nerd Font"
	vim.o.guifont = "MonoLisa,Symbols Nerd Font:h13"

	vim.g.neovide_underline_automatic_scaling = true
	vim.g.neovide_scale_factor = 0.83
	-- vim.g.neovide_floating_shadow = "v:true"
	-- vim.g.neovide_floating_z_height = 10
	vim.g.neovide_transparency = 1
	vim.g.neovide_padding_top = 10
	vim.g.neovide_padding_left = 10

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 5
	vim.g.neovide_padding_right = 10
	vim.g.neovide_padding_left = 10

	vim.g.neovide_hide_mouse_when_typing = true

	vim.g.neovide_scroll_animation_length = 0.1

	vim.g.neovide_theme = "auto"
	vim.g.neovide_refresh_rate = 165
	vim.g.neovide_confirm_quit = false
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_trail_length = 0.01
	vim.g.neovide_cursor_antialiasing = true

	vim.g.neovide_cursor_animate_in_insert_mode = true
	vim.g.neovide_cursor_animate_in_normal_mode = true
	vim.g.neovide_cursor_animate_in_visual_mode = true
	vim.g.neovide_cursor_animate_in_replace_mode = true
	vim.g.neovide_cursor_animate_in_command_mode = true

	vim.g.neovide_floating_shadow = true

	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_floating_z_height = 10
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 5

	-- -- Helper function for transparency formatting
	-- local alpha = function()
	-- 	return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
	-- end
	-- -- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
	-- vim.g.neovide_transparency = 0.9
	-- vim.g.transparency = 0.0
	-- vim.g.neovide_background_color = require("theme").get_colors().base .. alpha()

	vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
	vim.keymap.set("v", "<D-c>", '"+y') -- Copy
	vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
