local M = {}

-- M._theme = require("themes.base16.theme")
-- M._theme = require("themes.alabaster.theme")
M._theme = require("themes.catppuccin.theme")
M._theme = require("themes.catppuccin.minimal_theme")
-- M._theme = require("themes.default.theme")

function M.setup()
    if M._theme ~= nil then
        M._theme.setup()

        local ok, fwatch = pcall(require, "fwatch")

        if ok then
            fwatch.watch("/tmp/tmux-theme.cache", {
                on_event = function()
                    vim.schedule(function()
                        M._theme.setup()
                        require("tiny-devicons-auto-colors").apply(M._theme.get_colors())
                        local plugin = require("lazy.core.config").plugins["lualine.nvim"]
                        require("lazy.core.loader").reload(plugin)
                        require("lualine").refresh()
                    end)
                end,
            })
        end
    end
end

function M.get_colors()
    if M._theme == nil then
        return {}
    end
    return M._theme.get_colors()
end

function M.get_lualine_colors()
    if M._theme == nil then
        return {}
    end
    return M._theme.get_lualine_colors()
end

function M.get_kirby_colors()
    local colors = M.get_lualine_colors()

    return {
        n = colors.red,
        i = colors.green,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.mauve,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
    }
end

return M
