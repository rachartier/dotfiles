local M = {
    "utilyre/barbecue.nvim",
    enabled = true,
    name = "barbecue",
    version = "*",
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
    },
}

function M.config()
    require('barbecue').setup({
        theme = "catppuccin",
        integrations = {
            barbecue = {
                dim_dirname = true,
                bold_basename = true,
                dim_context = false,
            }
        }
    })
end

return M
