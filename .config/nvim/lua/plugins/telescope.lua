local M = {
    'nvim-telescope/telescope.nvim',
    -- TODO: vérifier les nouveaux commits pour éviter le bug de treesitter...
    commit = "057ee0f8783872635bc9bc9249a4448da9f99123",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-dap.nvim'
    }
}

local function fuzzy_find_under_cursor()
    local builtin = require("telescope.builtin")
    local word_under_cursor = vim.fn.expand("<cword>")
    builtin.current_buffer_fuzzy_find({ default_text = word_under_cursor })
end

function M.config()
    require('telescope').load_extension('dap')
    require("telescope").load_extension('harpoon')

    local ts = require 'telescope'

    ts.setup({
        defaults = {
            sort_mru = true,
            sorting_strategy = 'ascending',
            layout_config = {
                prompt_position = 'top'
            },
            multi_icon = '',
            entry_prefix = '   ',
            prompt_prefix = '   ',
            selection_caret = '  ',
            hl_result_eol = true,
            results_title = "",
        }
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = "Find all LSP references" })
    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find git files" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Grep words inside files" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Show documentations" })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "Grep string under cursor" })
    vim.keymap.set('n', '<leader>fn', require("nvim-navbuddy").open, { desc = "Open NavBuddy" })
    vim.keymap.set('n', '<leader>fm', "<cmd>Telescope harpoon marks<cr>", { desc = "Open Harpoon Marks" })
    vim.keymap.set('n', '*', fuzzy_find_under_cursor, { desc = "Fuzzy find in file under cursor" })

    vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "Select theme" })
end

return M
