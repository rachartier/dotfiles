local M = {
     "goolord/alpha-nvim",
}

function M.config()
    local alpha = require'alpha'
    local dashboard = require'alpha.themes.dashboard'
    dashboard.section.header.val = {

        [[         ,--.              ,----..                                 ____  ]],
        [[       ,--.'|    ,---,.   /   /   \                 ,---,        ,'  , `.]],
        [[   ,--,:  : |  ,'  .' |  /   .     :        ,---.,`--.' |     ,-+-,.' _ |]],
        [[,`--.'`|  ' :,---.'   | .   /   ;.  \      /__./||   :  :  ,-+-. ;   , ||]],
        [[|   :  :  | ||   |   .'.   ;   /  ` ; ,---.;  ; |:   |  ' ,--.'|'   |  ;|]],
        [[:   |   \ | ::   :  |-,;   |  ; \ ; |/___/ \  | ||   :  ||   |  ,', |  ':]],
        [[|   : '  '; |:   |  ;/||   :  | ; | '\   ;  \ ' |'   '  ;|   | /  | |  ||]],
        [['   ' ;.    ;|   :   .'.   |  ' ' ' : \   \  \: ||   |  |'   | :  | :  |,]],
        [[|   | | \   ||   |  |-,'   ;  \; /  |  ;   \  ' .'   :  ;;   . |  ; |--' ]],
        [['   : |  ; .''   :  ;/| \   \  ',  /    \   \   '|   |  '|   : |  | ,    ]],
        [[|   | '`--'  |   |    \  ;   :    /      \   `  ;'   :  ||   : '  |/     ]],
        [['   : |      |   :   .'   \   \ .'        :   \ |;   |.' ;   | |`-'      ]],
        [[;   |.'      |   | ,'      `---`           '---" '---'   |   ;/          ]],
        [['---'        `----'                                      '---'           ]]
    }
    dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("SPC f f", "  Find file"),
        dashboard.button("SPC f g", "  Live grep"),
        dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ | e init.lua<CR>"),
        dashboard.button("l", "  Open Lazy", "<cmd>Lazy<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }
    local handle = io.popen('fortune')

    if handle ~= nil then
        local fortune = handle:read("*a")
        handle:close()
        dashboard.section.footer.val = fortune
    end

    dashboard.config.opts.noautocmd = true

    vim.cmd[[autocmd User AlphaReady echo 'ready']]

    alpha.setup(dashboard.config)

end

return M
