local M = {}

function M.get_colors()
    return nil
end

function M.get_lualine_colors()
    --

    return {
        bg = "#c9c9c9",
        mantle = "#c9c9c9",
        crust = "#222222",
        fg = "#222222",
        surface0 = "#666666",
        yellow = "#cb9000",
        flamingo = "#cb9000",
        cyan = "#222222",
        darkblue = "#222222",
        green = "#222222",
        orange = "#cb9000",
        violet = "#7a3e9d",
        mauve = "#7a3e9d",
        blue = "#222222",
        red = "#222222",
    }

    --     color1 = "#c9c9c9",
    --     color2 = "#cb9000",
    --     color3 = "#222222",
    --     color4 = "#666666",
    --     color5 = "#aaaaaa",
    --     color6 = "#7a3e9d",
    -- }
end

function M.setup()
    vim.cmd([[set bg=dark]])
    vim.cmd.colorscheme("alabaster")
    vim.cmd([[echo " "]]) -- fix flickering... https://github.com/neovim/neovim/issues/19362
    -- require("themes.groups").override_hl(M.get_colors())
    -- require("themes.groups").override_lsp_hl(M.get_colors())
end

return M
