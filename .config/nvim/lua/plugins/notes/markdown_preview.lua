local M = {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
}

function M.config()
    require("glow").setup({
        border = "rounded",
    })
end

return {
    M,
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
    },
    {
        -- "richardbizik/nvim-toc",
        -- config = function()
        --     require("nvim-toc").setup({})
        -- end,
    },
}
