
local M = {
    'ggandor/leap.nvim',
    dependencies = "tpope/vim-repeat"
}

function M.config()
    require('leap').add_default_mappings()
end

return M
