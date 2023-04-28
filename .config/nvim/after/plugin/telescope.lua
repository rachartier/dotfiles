require('telescope').load_extension('dap')
require("telescope").load_extension('harpoon')

local ts = require 'telescope'
local u = require 'utils'

ts.setup({
    defaults = {
        sort_mru = true,
        sorting_strategy = 'ascending',
        layout_config = {
            prompt_position = 'top'
        },
        borderchars = {
            prompt = u.border_chars_outer_thin_telescope,
            results = u.border_chars_outer_thin_telescope,
            preview = u.border_chars_outer_thin_telescope
        },
        border = true,
        multi_icon = '',
        entry_prefix = '   ',
        prompt_prefix = '   ',
        selection_caret = '  ',
        hl_result_eol = true,
        results_title = "",
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc="Find files"})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc="Find buffers"})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {desc="Find all LSP references"})
vim.keymap.set('n', '<C-p>', builtin.git_files, {desc="Find git files"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc="Grep words inside files"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc="Show documentations"})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {desc="Grep string under cursor"})
vim.keymap.set('n', '<leader>fn',  require("nvim-navbuddy").open, {desc="Open NavBuddy"})
vim.keymap.set('n', '<leader>fm',  "<cmd>Telescope harpoon marks<cr>", {desc="Open Harpoon Marks"})


