local M = {
    "shortcuts/no-neck-pain.nvim"
}

function M.config()
    require("no-neck-pain").setup({
        width = 150,
        buffers = {
            setNames = false,
            colors = {
                blend = -0.3,
            },
            right = {
                enabled = false,
            },

            scratchPad = {
                enabled = true,
                location = "~/.config/nvim/notes/scratchpad/",
            },
            bo = {
                filetype = "md"
            },
        },
        autocmds = {
            enableOnVimEnter = true,
        },
        mappings = {
            -- When `true`, creates all the mappings that are not set to `false`.
            --- @type boolean
            enabled = true,
            toggle = "<Leader>np",
            widthUp = false,
            widthDown = false,
            scratchPad = false,
        }
    })
end

return M
