if require("lazy.core.config").plugins["barbecue"] then
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
