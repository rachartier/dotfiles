local M = {
    "nvim-telescope/telescope.nvim",
    -- TODO: vérifier les nouveaux commits pour éviter le bug de treesitter...
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
        "<leader>ff",
        "<leader>fg",
        "<Tab>",
        "<S-Tab>",
    },
}

local function fuzzy_find_under_cursor()
    local builtin = require("telescope.builtin")
    local word_under_cursor = vim.fn.expand("<cword>")
    builtin.current_buffer_fuzzy_find({
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "bottom",
        },

        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        default_text = word_under_cursor,
    })
end

function M.config()
    require("telescope").load_extension("dap")
    require("telescope").load_extension("harpoon")

    local U = require("utils")
    local ts = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function flash(prompt_bufnr)
        require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
                mode = "search",
                exclude = {
                    function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                    end,
                },
            },
            action = function(match)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                picker:set_selection(match.pos[1] - 1)
                actions.select_default()
            end,
        })
    end

    local search_layout = {
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "bottom",
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    }

    ts.setup({
        defaults = {
            borderchars = {
                --        { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

                prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
            },
            sort_mru = true,
            sorting_strategy = "ascending",
            layout_config = {
                prompt_position = "top",
            },
            multi_icon = "",
            entry_prefix = "   ",
            prompt_prefix = "   ",
            selection_caret = "  ",
            hl_result_eol = true,
            results_title = "",
            mappings = {
                n = { s = flash },
                i = { ["<c-s>"] = flash },
            },
            file_ignore_patterns = { "node_modules", "__pycache__", "bin", "obj" },
        },
        pickers = {
            find_files = {},
            grep_string = search_layout,
            live_grep = search_layout,
            lsp_references = search_layout,
            buffers = {
                borderchars = {
                    prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                    preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
                },
                show_all_buffers = true,
                sort_lastused = true,
                theme = "dropdown",
                previewer = false,
                mappings = {
                    i = {
                        ["<C-d>"] = "delete_buffer",
                        ["<S-d>"] = require("utils").buffers_clean,
                        ["<S-Tab>"] = "move_selection_previous",
                        ["<Esc>"] = "close",
                        ["<Tab>"] = "move_selection_next",
                    },
                },
            },
        },
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    -- vim.keymap.set("n", "<Tab>", builtin.buffers, { desc = "Find buffers" })
    -- vim.keymap.set("n", "<S-Tab>", builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set(
        "n",
        "<leader>fr",
        "<cmd>Telescope lsp_references show_line=false<cr>",
        { desc = "Find all LSP references" }
    )
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find git files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep words inside files" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Show documentations" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep string under cursor" })
    vim.keymap.set("n", "<leader>fn", require("nvim-navbuddy").open, { desc = "Open NavBuddy" })
    vim.keymap.set("n", "<leader>fm", "<cmd>Telescope harpoon marks<cr>", { desc = "Open Harpoon Marks" })
    vim.keymap.set("n", "*", fuzzy_find_under_cursor, { desc = "Fuzzy find in file under cursor" })

    vim.keymap.set("n", "<leader>fl", builtin.resume)
end

return M
