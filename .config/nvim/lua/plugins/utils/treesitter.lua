local M = {
    "nvim-treesitter/nvim-treesitter",
    -- build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/playground",
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
}

function M.config()
    require("nvim-treesitter.configs").setup({
        ignore_install = {},
        modules = {},
        ensure_installed = {
            "markdown_inline",
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        -- playground = {
        -- 	enable = false,
        -- 	disable = {},
        -- 	updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        -- 	persist_queries = false, -- Whether the query persists across vim sessions
        -- 	keybindings = {
        -- 		toggle_query_editor = "o",
        -- 		toggle_hl_groups = "i",
        -- 		toggle_injected_languages = "t",
        -- 		toggle_anonymous_nodes = "a",
        -- 		toggle_language_display = "I",
        -- 		focus_language = "f",
        -- 		unfocus_language = "F",
        -- 		update = "R",
        -- 		goto_node = "<cr>",
        -- 		show_help = "?",
        -- 	},
        -- },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                node_decremental = "<BS>",
            },
        },
        indent = {
            enable = true,
        },
    })

    vim.api.nvim_set_hl(0, "@string.documentation.python", { link = "Comment" })
    vim.treesitter.language.register("lua", "pico8")
end

return M
