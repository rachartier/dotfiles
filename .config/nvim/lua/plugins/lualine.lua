local M = {
    "nvim-lualine/lualine.nvim",
    enabled = true,
}

function M.config()
    local c = require("catppuccin.palettes").get_palette("mocha")
    local colors = {
        bg = c.base,
        fg = c.text,
        yellow = c.yellow,
        cyan = c.cyan,
        darkblue = c.mantle,
        green = c.green,
        orange = c.peach,
        violet = c.lavender,
        magenta = c.mauve,
        blue = c.blue,
        red = c.red,
    }

    local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
            }
        end
    end

    local function get_current_buftype()
        return vim.api.nvim_buf_get_option(0, "buftype")
    end

    local function get_current_filename()
        local bufname = vim.api.nvim_buf_get_name(0)
        return bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
    end

    Icon_hl_cache = {}
    local lualine_require = require("lualine_require")
    local modules = lualine_require.lazy_require({
        highlight = "lualine.highlight",
        utils = "lualine.utils.utils",
    })

    function M:get_current_filetype_icon()
        -- Get setup.
        local icon, icon_highlight_group
        local _, devicons = pcall(require, "nvim-web-devicons")
        local f_name, f_extension = vim.fn.expand("%:t"), vim.fn.expand("%:e")
        f_extension = f_extension ~= "" and f_extension or vim.bo.filetype
        icon, icon_highlight_group = devicons.get_icon(f_name, f_extension)

        if icon == nil and icon_highlight_group == nil then
            icon = ""
            icon_highlight_group = "DevIconDefault"
        end

        local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, "fg")
        if highlight_color then
            local default_highlight = self:get_default_hl()
            local icon_highlight = Icon_hl_cache[highlight_color]
            if not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. "_normal") then
                icon_highlight = self:create_hl({ fg = highlight_color }, icon_highlight_group)
                Icon_hl_cache[highlight_color] = icon_highlight
            end
            icon = self:format_hl(icon_highlight) .. icon .. default_highlight
        end

        return icon
    end

    function M:get_current_filename_with_icon()
        local suffix = " "

        local icon = M.get_current_filetype_icon(self)
        local f_name = get_current_filename()

        local readonly = vim.api.nvim_buf_get_option(0, "readonly")
        local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
        local nofile = get_current_buftype() == "nofile"
        if readonly or nofile or not modifiable then
            suffix = " "
        end

        return icon .. " " .. f_name .. suffix
    end

    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
            local filepath = vim.fn.expand("%:p:h")
            local gitdir = vim.fn.finddir(".git", filepath .. ";")
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
    }

    local config = {
        options = {
            component_separators = "",
            section_separators = "",
            theme = {
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg } },
            },
        },
        sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            lualine_a = {},
            lualine_v = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
    }

    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    ins_left({
        function()
            return "▊"
        end,
        color = { fg = colors.blue }, -- Sets highlighting of component
        left_padding = 0,       -- We don't need space before this
    })

    ins_left({
        -- mode component
        function()
            -- auto change color according to neovims mode
            local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [""] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
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
            vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
            local kirby_default = "(>*-*)>"
            local mode_kirby = {
                n = "<(•∪•)>",
                i = "<(•o•)>",
                v = "(v•-•)v",
                [""] = "(v•-•)>",
                V = "(>•-•)>",
                c = kirby_default,
                no = "<(•∪•)>",
                s = kirby_default,
                S = kirby_default,
                [""] = kirby_default,
                ic = kirby_default,
                R = kirby_default,
                Rv = kirby_default,
                cv = "<(•∪•)>",
                ce = "<(•∪•)>",
                r = kirby_default,
                rm = kirby_default,
                ["r?"] = kirby_default,
                ["!"] = "<(•∪•)>",
                t = "<(•∪•)>",
            }
            return mode_kirby[vim.fn.mode()]
        end,
        color = "LualineMode",
        left_padding = 0,
    })

    ins_left({
        -- filesize component
        function()
            local function format_file_size(file)
                local size = vim.fn.getfsize(file)
                if size <= 0 then
                    return ""
                end
                local sufixes = { "b", "k", "m", "g" }
                local i = 1
                while size > 1024 do
                    size = size / 1024
                    i = i + 1
                end
                return string.format("%.1f%s", size, sufixes[i])
            end
            local file = vim.fn.expand("%:p")
            if string.len(file) == 0 then
                return ""
            end
            return format_file_size(file)
        end,
        condition = conditions.buffer_not_empty,
    })

    ins_left({
        M.get_current_filename_with_icon,
        condition = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = "bold" },
    })
    ins_left({
        "diagnostics",
        sources = { "nvim_lsp" },
        symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = "󱤅 ",
            other = "󰠠 ",
        },
        diagnostics_color = {
            error = { fg = c.error, gui = "bold" },
            warn = { fg = c.warn, gui = "bold" },
            info = { fg = c.info, gui = "bold" },
            hint = { fg = c.hint, gui = "bold" },
        },
        colored = true,
    })

    ins_left({
        "branch",
        icon = "",
        color = { fg = colors.violet, gui = "bold" },
    })
    ins_left({
        "diff",
        colored = true,
        source = diff_source,
        symbols = {
            added = " ",
            modified = " ",
            removed = " ",
        },
        diff_color = {
            added = { gui = "bold" },
            modified = { gui = "bold" },
            removed = { gui = "bold" },
        },
    })

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left({
        function()
            return "%="
        end,
    })

    ins_left({
        -- Lsp server name .
        function()
            local msg = "No Active Lsp"
            local text_clients = ""
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()

            if next(clients) == nil then
                return msg
            end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    text_clients = text_clients .. client.name .. ", "
                end
            end
            if text_clients ~= "" then
                return text_clients:sub(1, -3)
            end
            return msg
        end,
        icon = " LSP:",
        color = { fg = colors.text, gui = "bold" },
    })

    -- Add components to right sections
    ins_right({
        "o:encoding", -- option component same as &encoding in viml
        upper = true, -- I'm not sure why it's upper case either ;)
        condition = conditions.hide_in_width,
        color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
        "fileformat",
        upper = true,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = "bold" },
    })

    ins_right({ "location" })

    ins_right({ "progress", color = { fg = colors.fg, gui = "bold" } })

    require("lualine").setup(config)
end

return M
