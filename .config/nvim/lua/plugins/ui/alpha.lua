local M = {
    "goolord/alpha-nvim",
    event = "VimEnter",
}

function M.config()
    local alpha = require("alpha")
    require("alpha.term")
    local dashboard = require("alpha.themes.dashboard")

    local header = {
        type = "terminal",
        command = "chafa $HOME/.config/nvim/dashboard/gif/kirby-dancing.gif",
        width = 24,
        height = 14,
        opts = {
            redraw = true,
            window_config = {},
            position = "center",
        },
    }
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        desc = "Add Alpha dashboard footer",
        once = true,
        callback = function()
            local stats = require("lazy").stats()
            local ms = math.floor(stats.startuptime * 100) / 100

            dashboard.section.footer.val = {
                " ",
                " ",
                "Loaded " .. stats.loaded .. " plugins (" .. stats.count .. " total)   in " .. ms .. "ms",
            }

            pcall(vim.cmd.AlphaRedraw)
        end,
    })

    -- dashboard.section.header.val = {
    -- [[         ,--.              ,----..                                 ____  ]],
    -- [[       ,--.'|    ,---,.   /   /   \                 ,---,        ,'  , `.]],
    -- [[   ,--,:  : |  ,'  .' |  /   .     :        ,---.,`--.' |     ,-+-,.' _ |]],
    -- [[,`--.'`|  ' :,---.'   | .   /   ;.  \      /__./||   :  :  ,-+-. ;   , ||]],
    -- [[|   :  :  | ||   |   .'.   ;   /  ` ; ,---.;  ; |:   |  ' ,--.'|'   |  ;|]],
    -- [[:   |   \ | ::   :  |-,;   |  ; \ ; |/___/ \  | ||   :  ||   |  ,', |  ':]],
    -- [[|   : '  '; |:   |  ;/||   :  | ; | '\   ;  \ ' |'   '  ;|   | /  | |  ||]],
    -- [['   ' ;.    ;|   :   .'.   |  ' ' ' : \   \  \: ||   |  |'   | :  | :  |,]],
    -- [[|   | | \   ||   |  |-,'   ;  \; /  |  ;   \  ' .'   :  ;;   . |  ; |--' ]],
    -- [['   : |  ; .''   :  ;/| \   \  ',  /    \   \   '|   |  '|   : |  | ,    ]],
    -- [[|   | '`--'  |   |    \  ;   :    /      \   `  ;'   :  ||   : '  |/     ]],
    -- [['   : |      |   :   .'   \   \ .'        :   \ |;   |.' ;   | |`-'      ]],
    -- [[;   |.'      |   | ,'      `---`           '---" '---'   |   ;/          ]],
    -- [['---'        `----'                                      '---'           ]],
    --
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⣠⡶⠒⠒⠶⣄⣠⡴⠚⠁⠀⠀⠀⠀⠀⠉⠙⠳⢦⠀⠀⠀⠀⠀⠀]],
    -- [[⢠⡏⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⡀⠀⠀⠀⠀]],
    -- [[⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠋⢱⠀⠀⢠⠉⢡⠀⠀⠀⠀⠻⡄⠀⠀⠀]],
    -- [[⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⣧⣾⠄⠀⢸⣦⣾⠀⠀⠀⠀⠀⢻⡄⠀⠀]],
    -- [[⠀⠘⢧⡀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠸⣿⡿⠀⠀⠀⠀⠀⠈⠳⣄⠀]],
    -- [[⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠈⠁⡴⠶⡆⠉⠁⠀⠀⠀⠀⠀⠀⠀⠹⡄]],
    -- [[⠀⠀⠀⢷⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷]],
    -- [[⠀⠀⠀⠸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠇]],
    -- [[⠀⠀⠀⣀⡿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡽⣿⡛⠁⠀]],
    -- [[⠀⣠⢾⣭⠀⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠊⠀⢠⣝⣷⡀]],
    -- [[⢠⡏⠘⠋⠀⠀⠀⠈⠑⠦⣀⠀⠀⠀⠀⠀⣀⡠⠔⠋⠀⠀⠈⠛⠃⢻]],
    -- [[⠈⠷⣤⣀⣀⣀⣀⣀⣀⣀⣤⡽⠟⠛⠿⣭⣄⣀⣀⣀⣀⣀⣀⣀⣤⠞]],
    -- [[⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠀⠀⠀]],
    -- [[⠀⠀⠀⠀      NeoVIM          ]],
    --
    -- [[    ___       ___       ___       ___       ___       ___    ]],
    -- [[   /\__\     /\  \     /\  \     /\__\     /\  \     /\__\   ]],
    -- [[  /:| _|_   /::\  \   /::\  \   /:/ _/_   _\:\  \   /::L_L_  ]],
    -- [[ /::|/\__\ /::\:\__\ /:/\:\__\ |::L/\__\ /\/::\__\ /:/L:\__\ ]],
    -- [[ \/|::/  / \:\:\/  / \:\/:/  / |::::/  / \::/\/__/ \/_/:/  / ]],
    -- [[   |:/  /   \:\/  /   \::/  /   L;;/__/   \:\__\     /:/  /  ]],
    -- [[   \/__/     \/__/     \/__/               \/__/     \/__/   ]],
    -- [[                                                                       ]],
    -- [[                                                                     ]],
    -- [[       ████ ██████           █████      ██                     ]],
    -- [[      ███████████             █████                             ]],
    -- [[      █████████ ███████████████████ ███   ███████████   ]],
    -- [[     █████████  ███    █████████████ █████ ██████████████   ]],
    -- [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    -- [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    -- [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    -- [[                                                                       ]],
    -- }

    dashboard.section.buttons.val = {
        dashboard.button("e", "󰈔  New file", "<cmd>ene<CR>"),
        dashboard.button("SPC f f", "󰱼  Find file"),
        dashboard.button("SPC f g", "󰺮  Live grep"),
        dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ | e init.lua<CR>"),
        dashboard.button("l", "  Open Lazy", "<cmd>Lazy<CR>"),
        dashboard.button("q", "󰩈  Quit", "<cmd>qa<CR>"),
    }

    dashboard.config.layout = {
        { type = "padding", val = 2 },
        header,
        {
            type = "text",
            val = {
                "Neovim " .. string.format("%s", vim.version()),
            },
            opts = {
                position = "center",
                hl = "Type",
                -- wrap = "overflow";
            },
        },
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        dashboard.section.footer,
    }

    alpha.setup(dashboard.config)
end

return M
