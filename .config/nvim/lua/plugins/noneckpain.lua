local M = {
    "shortcuts/no-neck-pain.nvim"
}

function M.config()
    require("no-neck-pain").setup({
        width = 150,
        buffers = {
            setNames = false,
                blend = -0.3,
            left = {
                enabled = false,
            },
            scratchPad = {
                enabled = true,
                location = "~/.config/nvim/notes/scratchpad/",
                fileName = "scratchpad",
            },
            bo = {
                filetype = "md"
            },
        },
        autocmds = {
            enableOnTabEnter = true
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
