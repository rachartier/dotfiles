local M = {
    'nvim-tree/nvim-tree.lua',
    cmd = "NvimTreeToggle"
}

function M.config()
    local nvim_tree = require('nvim-tree')
    local u = require("utils")

    local gwidth = vim.api.nvim_list_uis()[1].width
    local gheight = vim.api.nvim_list_uis()[1].height
    local width = 60
    local height = 20

    nvim_tree.setup{
        view = {
            width = width,
            side = "right",
            float = {
                enable = true,
                open_win_config = {
                    relative = "editor",
                    border = u.border_chars_outer_thin,
                    width = width,
                    height = height,
                    row = (gheight - height) * 0.4,
                    col = (gwidth - width) * 0.5,
                }
            }
        },
        renderer = {
            root_folder_label = function(path)
                return vim.fn.fnamemodify(path, ":t")
            end,
            icons = {
                git_placement = "after",
                glyphs = {
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "✚",
                        deleted = "",
                        ignored = "◌",
                    }
                }
            }
        },
    }
end

return M
