-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('lazy').setup({
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-dap.nvim'
        }
    },
    { "aserowy/tmux.nvim" },
    {
        'navarasu/onedark.nvim',
        priority = 1000
    },
    {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
},
    { 'nvim-treesitter/nvim-treesitter' },
    { 'nvim-tree/nvim-tree.lua' },
    { 'mbbill/undotree' },
    { 'tpope/vim-fugitive' },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        }
    },
    {
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },

    { 'kdheepak/lazygit.nvim' },
    { 'onsails/lspkind.nvim' },
    { 'lukas-reineke/indent-blankline.nvim' },
    {
        'kosayoda/nvim-lightbulb',
        dependencies = 'antoinemadec/FixCursorHold.nvim',
    },

    { 'mfussenegger/nvim-jdtls' },
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "theHamsta/nvim-dap-virtual-text",
        },
        priority = 100
    },
    { "luukvbaal/statuscol.nvim" },
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
            "lewis6991/gitsigns.nvim"
        }
    },
    { "goolord/alpha-nvim", },
    { 'windwp/nvim-spectre' },
    { 'nvim-lualine/lualine.nvim' },
    { 'elpiloto/significant.nvim' },
    {
        'catppuccin/nvim',
        priority = 1000
    },
    { 'NTBBloodbath/sweetie.nvim',    priority = 1000 },
    { 'echasnovski/mini.surround',    version = false },
    { 'echasnovski/mini.splitjoin', version = false },
    {
        "utilyre/barbecue.nvim",
        enabled = true,
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
    },
    { "RRethy/vim-illuminate" },
    { 'uga-rosa/ccc.nvim' },
    {
        'renerocksai/telekasten.nvim',

        dependencies = {
            'godlygeek/tabular',
            'preservim/vim-markdown'
        }
    },
    {"folke/which-key.nvim"},
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        }
    },
    {
        "anuvyklack/hydra.nvim",
    },
    {
        'romgrk/barbar.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
    },
    {
        'ggandor/leap.nvim',
        dependencies = "tpope/vim-repeat"
    },
    {
        "ThePrimeagen/harpoon"
    },
    {
        "windwp/nvim-autopairs"
    },
})
