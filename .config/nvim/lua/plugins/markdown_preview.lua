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
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
}
