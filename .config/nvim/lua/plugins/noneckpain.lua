local M = {
    "shortcuts/no-neck-pain.nvim",
    enabled = false,
}

function M.config()
    require("no-neck-pain").setup({
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
                filetype = "md",
            },
        },
        autocmds = {
            enableOnTabEnter = true,
        },
        integrations = {
            undotree = {
                -- The position of the tree.
                --- @type "left"|"right"
                position = "left",
            },
        },
    })

    vim.keymap.set("n", "<leader>pp", "<cmd>NoNeckPain<CR>", { desc = "Toggle NoNeckPain" })
end

return M
