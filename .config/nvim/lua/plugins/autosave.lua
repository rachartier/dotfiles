local M = {
    "okuuva/auto-save.nvim",
}

function M.config()
    require("auto-save").setup({
        condition = function(buf)
            local fn = vim.fn

            -- don't save for special-buffers
            if fn.getbufvar(buf, "&buftype") ~= "" then
                return false
            end
            return true
        end,
    })
end

return M
