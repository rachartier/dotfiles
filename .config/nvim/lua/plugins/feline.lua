local M = {
    "freddiehaddad/feline.nvim",
    enabled = false,
}

function M.config()
    vim.g.termguicolors = true
    vim.opt.termguicolors = true

    local vi_mode_colors = {
        NORMAL = "green",
        OP = "green",
        INSERT = "yellow",
        VISUAL = "mauve",
        LINES = "peach",
        BLOCK = "red",
        REPLACE = "pink",
        COMMAND = "sapphire",
    }

    local c = {
        vim_mode = {
            provider = {
                name = "vi_mode",
                opts = {
                    show_mode_name = true,
                    -- padding = "center", -- Uncomment for extra padding.
                },
            },
            hl = function()
                return {
                    fg = "base",
                    bg = require("feline.providers.vi_mode").get_mode_color(),
                    style = "bold",
                    name = "NeovimModeHLColor",
                }
            end,
            left_sep = "block",
            right_sep = "block",
        },
        gitBranch = {
            provider = "git_branch",
            hl = {
                fg = "flamingo",
                bg = "bg",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        gitDiffAdded = {
            provider = "git_diff_added",
            hl = {
                fg = "green",
                bg = "bg",
            },
            left_sep = "block",
            right_sep = "block",
        },
        gitDiffRemoved = {
            provider = "git_diff_removed",
            hl = {
                fg = "red",
                bg = "bg",
            },
            left_sep = "block",
            right_sep = "block",
        },
        gitDiffChanged = {
            provider = "git_diff_changed",
            hl = {
                fg = "yellow",
                bg = "bg",
            },
            left_sep = "block",
            right_sep = "right_filled",
        },
        separator = {
            provider = "",
        },
        fileinfo = {
            provider = {
                name = "file_info",
                opts = {
                    type = "relative-short",
                },
            },
            hl = {
                style = "bold",
            },
            left_sep = " ",
            right_sep = " ",
        },
        diagnostic_errors = {
            provider = "diagnostic_errors",
            hl = {
                fg = "red",
            },
        },
        diagnostic_warnings = {
            provider = "diagnostic_warnings",
            hl = {
                fg = "yellow",
            },
        },
        diagnostic_hints = {
            provider = "diagnostic_hints",
            hl = {
                fg = "sapphir",
            },
        },
        diagnostic_info = {
            provider = "diagnostic_info",
        },
        lsp_client_names = {
            provider = "lsp_client_names",
            hl = {
                fg = "mauve",
                bg = "bg",
                style = "bold",
            },
            left_sep = "left_filled",
            right_sep = "block",
        },
        file_type = {
            provider = {
                name = "file_type",
                opts = {
                    filetype_icon = true,
                    case = "titlecase",
                },
            },
            hl = {
                fg = "red",
                bg = "bg",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        file_encoding = {
            provider = "file_encoding",
            hl = {
                fg = "orange",
                bg = "bg",
                style = "italic",
            },
            left_sep = "block",
            right_sep = "block",
        },
        position = {
            provider = "position",
            hl = {
                fg = "green",
                bg = "bg",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        line_percentage = {
            provider = "line_percentage",
            hl = {
                fg = "sapphir",
                bg = "bg",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        scroll_bar = {
            provider = "scroll_bar",
            hl = {
                fg = "yellow",
                style = "bold",
            },
        },
    }

    local left = {
        c.vim_mode,
        c.gitBranch,
        c.gitDiffAdded,
        c.gitDiffRemoved,
        c.gitDiffChanged,
        c.separator,
    }

    local middle = {
        c.fileinfo,
        c.diagnostic_errors,
        c.diagnostic_warnings,
        c.diagnostic_info,
        c.diagnostic_hints,
    }

    local right = {
        c.lsp_client_names,
        c.file_type,
        c.file_encoding,
        c.position,
        c.line_percentage,
        c.scroll_bar,
    }

    local components = {
        active = {
            left,
            middle,
            right,
        },
        inactive = {
            left,
            middle,
            right,
        },
    }

    require("feline").setup({
        components = components,
        theme = require("catppuccin.palettes").get_palette("mocha"),
        vi_mode_colors = vi_mode_colors,
        force_inactive = {
            filetypes = {
                "NvimTree",
                "packer",
                "dap-repl",
                "dapui_scopes",
                "dapui_stacks",
                "dapui_watches",
                "dapui_repl",
                "LspTrouble",
                "qf",
                "help",
            },
            buftypes = { "terminal" },
            bufnames = {},
        },
    })
end

return M
