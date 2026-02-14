if vim.g.neovide then
  vim.o.guifont = "Berkeley Mono,Symbols Nerd Font:h16"

  vim.g.neovide_underline_stroke_scale = 1.5

  vim.g.neovide_cursor_animate_command_line = true

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

  vim.g.neovide_floating_blur_amount_x = 2
  vim.g.neovide_floating_blur_amount_y = 2
  vim.g.neovide_floating_z_height = 5
  vim.g.neovide_floating_corner_radius = 0.0
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.g.neovide_normal_opacity = 1
  vim.g.neovide_opacity = 1

  vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "save file" })
  vim.keymap.set("v", "<D-c>", '"+y', { desc = "copy to clipboard" })
  vim.keymap.set("n", "<D-v>", '"+P', { desc = "paste from clipboard" })
  vim.keymap.set("v", "<D-v>", '"+P', { desc = "paste from clipboard" })
  vim.keymap.set("c", "<D-v>", "<C-R>+", { desc = "paste from clipboard" })
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli', { desc = "paste from clipboard" })

  vim.keymap.set("n", "<C-S>", '"+P', { desc = "paste from clipboard" })
  vim.keymap.set("v", "<C-S>", '"+P', { desc = "paste from clipboard" })

  vim.keymap.set("n", "<C-S-v>", '"+P', { desc = "paste from clipboard" })
  vim.keymap.set("v", "<C-S-v>", '"+P', { desc = "paste from clipboard" })
  vim.keymap.set("i", "<C-S-v>", '<ESC>l"+Pli', { desc = "paste from clipboard" })
end

vim.keymap.set("", "<D-v>", "+p<CR>", { noremap = true, silent = true, desc = "paste from clipboard" })
vim.keymap.set("!", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "paste from clipboard" })
vim.keymap.set("t", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "paste from clipboard" })
vim.keymap.set("v", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "paste from clipboard" })
