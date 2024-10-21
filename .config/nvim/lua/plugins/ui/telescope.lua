local icons = require("config.icons")

local function flash(prompt_bufnr)
	local actions = require("telescope.actions")
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
	word_match = "-w",
	only_sort_text = true,
	search = "",
	layout_strategy = "vertical",
	line_width = "full",
	find_command = { "rg", "--files", "--sortr=modified", "--fixed-string" },
	layout_config = {
		prompt_position = "bottom",
		vertical = {
			width = 0.9,
			height = 0.9,
			preview_height = 0.6,
			preview_cutoff = 0,
		},
	},
	set_style = {
		result = {
			spacing = 0,
			indentation = 2,
			dynamic_width = true,
		},
	},
	borderchars = icons.border.square_telescope,
}

return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	cmd = "Telescope",
    -- stylua: ignore
    keys = {
        { "<leader>f", "", "+telescope", mode = {"n"} },
        { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files"  },
        {  "<leader>fr", "<cmd>Telescope lsp_references show_line=false<cr>",  desc = "Find all LSP references"  },
        -- { "n", "<C-p>", require("telescope.builtin").git_files, { desc = "Find git files" } },
        {  "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Grep words inside files" },
        {  "<leader>fd", "<cmd>Telescope diagnostics", desc = "Find all diagnostics"  },
        {  "<leader>fw", "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<cr>",  desc = "Grep string under cursor"  },
        {  "<leader>ss", "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))<cr>",  desc = "Spelling Suggestions"  },
        {  "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Resume" }
    },
	opts = {
		defaults = {
			winblend = require("config").winblend,
			-- borderchars = icons.default_border,
			-- { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

			borderchars = icons.border.square_telescope,
			set_env = { ["COLORTERM"] = "truecolor" },
			prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
			preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
			sort_mru = true,
			sorting_strategy = "ascending",
			selection_strategy = "reset",
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
			path_display = { "filename_first" },
			vimgrep_arguments = {
				"rg",
				"-L",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			layout_config = {
				horizontal = {

					preview_cutoff = 200,
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.60,
				height = 0.60,
			},
		},
		pickers = {
			find_files = {
				find_command = { "rg", "--files", "--sortr=modified" },
			},
			grep_string = search_layout,
			live_grep = search_layout,
			lsp_references = search_layout,
			diagnostics = search_layout,
			buffers = {
				-- borderchars = icons.default_border,
				-- borderchars = {
				--     prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
				--     results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
				--     preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
				-- },
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
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},

			advanced_git_search = {
				diff_plugin = "diffview",
			},
		},
	},
	config = function(_, opts)
		require("telescope").setup(opts)

		require("telescope").load_extension("fzf")
	end,
}
