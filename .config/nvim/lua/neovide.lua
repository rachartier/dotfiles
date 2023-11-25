if vim.g.neovide then
    vim.o.guifont = "CaskaydiaCove NF"
    vim.g.neovide_underline_stroke_scale = 1.5

    vim.g.neovide_padding_top = 10
    vim.g.neovide_padding_bottom = 10
    vim.g.neovide_padding_right = 10
    vim.g.neovide_padding_left = 10

    vim.g.neovide_scale_factor = 1.0

    vim.g.neovide_hide_mouse_when_typing = true

    vim.g.neovide_scroll_animation_length = 0.1

    vim.g.neovide_theme = "auto"
    -- vim.g.neovide_refresh_rate = 144
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_trail_length = 10
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
    vim.g.neovide_cursor_vfx_particle_speed = 20.0
    vim.g.neovide_cursor_vfx_particle_density = 10.0

    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_in_normal_mode = true
    vim.g.neovide_cursor_animate_in_visual_mode = true
    vim.g.neovide_cursor_animate_in_replace_mode = true
    vim.g.neovide_cursor_animate_in_command_mode = true

    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5

    -- -- Helper function for transparency formatting
    -- local alpha = function()
    --     return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    -- end
    -- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    -- vim.g.neovide_transparency = 0.0
    -- vim.g.transparency = 0.8
    -- vim.g.transparency = 0.8
    -- vim.g.neovide_background_color = colors.base .. alpha()
    vim.keymap.set("n", "<D-s>", ":w<CR>")   -- Save
    vim.keymap.set("v", "<D-c>", '"+y')      -- Copy
    vim.keymap.set("n", "<D-v>", '"+P')      -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P')      -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+")   -- Paste command mode
    vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end
