return {
    "nvim-pack/nvim-spectre",
    keys = {
        {
            "<leader>R",
            '<cmd>lua require("spectre").open()<CR>',
            desc = "Open Spectre",
        },
        {
            "<leader>rw",
            '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
            desc = "Search current word",
        },
        {
            "<leader>rw",
            '<esc><cmd>lua require("spectre").open_visual()<CR>',
            desc = "Search current word",
        },
        {
            "<leader>rp",
            '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
            desc = "Search on current file",
        },
    },
    config = function()
        require("utils").on_event("FileType", function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
        end, {
            target = "*spectre*",
            desc = "Disable line numbers on Spectre buffer",
        })
    end
}
