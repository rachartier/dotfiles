local M = {
    "Exafunction/codeium.vim",
    event = "BufEnter",
}

function M.config()
    vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
    end, { expr = true })
    vim.keymap.set("i", "<c-q>", function()
        return vim.fn["codeium#CycleCompletions"](2)
    end, { expr = true })
    vim.keymap.set("i", "<c-s>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true })
    vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
    end, { expr = true })
end

return M
