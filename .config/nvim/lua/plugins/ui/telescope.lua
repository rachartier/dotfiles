return {
	"nvim-telescope/telescope.nvim",
	-- TODO: vérifier les nouveaux commits pour éviter le bug de treesitter...
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		{

			"isak102/telescope-git-file-history.nvim",
			keys = {
				"<leader>fh",
			},
			dependencies = { "tpope/vim-fugitive" },
		},
	},
	cmd = "Telescope",
	keys = {
		"<leader>fl",
		"<leader>fw",
		"<leader>tt",
		"<leader>ff",
		"<leader>fg",
		"<leader>fh",
		"<leader>fr",
		"<leader>fb",
		-- { "<Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
		-- { "<S-Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
	},
	enabled = false,
	config = function()
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

		local ts = require("telescope")
		local actions = require("telescope.actions")
		local gfh_actions = require("telescope").extensions.git_file_history.actions

		local default_border = require("config.icons").default_border
		if default_border == "rounded" then
			default_border = require("config.icons").border.rounded_telescope
		end

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
			word_match = "-w",
			only_sort_text = true,
			search = "",
			layout_strategy = "vertical",
			line_width = "full",
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
			borderchars = default_border,
		}

		ts.setup({
			defaults = {
				winblend = require("config").winblend,
				-- borderchars = icons.default_border,
				-- { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

				prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
				results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
				preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
				sort_mru = true,
				sorting_strategy = "ascending",
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
				git_file_history = {
					mappings = {
						i = {
							["<C-g>"] = gfh_actions.open_in_browser,
						},
						n = {
							["<C-g>"] = gfh_actions.open_in_browser,
						},
					},
				},
			},
		})

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("git_file_history")

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
		-- vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find git files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep words inside files" })
		vim.keymap.set(
			"n",
			"<leader>fh",
			require("telescope").extensions.git_file_history.git_file_history,
			{ desc = "Open Git File History" }
		)
		vim.keymap.set("n", "<leader>tt", builtin.diagnostics, { desc = "Find all diagnostics" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep string under cursor" })
		vim.keymap.set("n", "<leader>ss", function()
			require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
		end, { desc = "Spelling Suggestions" })
		-- vim.keymap.set("n", "*", fuzzy_find_under_cursor, { desc = "Fuzzy find in file under cursor" })

		vim.keymap.set("n", "<leader>fl", builtin.resume)
	end,
}
