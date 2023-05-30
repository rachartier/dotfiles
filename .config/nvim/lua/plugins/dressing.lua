local M = {
    'stevearc/dressing.nvim',
    enabled = false,
}

function M.config()
    require('dressing').setup({
        select = {
            get_config = function(opts)
                if opts.kind == 'codeaction' then
                    return {
                        backend = 'nui',
                        nui = {
                            relative = 'cursor',
                            max_width = 40,
                        }
                    }
                end
            end
        }
    })
end

return M
