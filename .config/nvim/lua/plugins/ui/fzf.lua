local M = {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		"<leader>ff",
		"<leader>fb",
		"<leader>fr",
		"<leader>fG",
		"<leader>fg",
		"<leader>fl",
		"<leader>fw",
		"<leader>ft",
		"<leader>ft",
		-- { "<Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
		-- { "<S-Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
	},
	enabled = false,
}

function M.config()
	local fzf = require("fzf-lua")
	local signs = require("config.ui.signs")

	fzf.setup({
		winopts = {
			border = require("config.ui.border").default_border,
			width = 0.8,
			height = 0.8,
			row = 0.5,
			col = 0.5,
			backdrop = 100,
			preview = {
				delay = 0,
				scrollchars = { "┃", "" },
			},
		},
		keymap = {
			fzf = {
				["change"] = "top",
				["tab"] = "down",
				["shift-tab"] = "up",
			},
		},
		files = {
			formatter = "path.filename_first",
			ignore_patterns = { "*.gif" },
			fd_opts = "--type f --hidden --follow",
		},
		diagnostics = {
			winopts = {
				preview = { hidden = "hidden" },
			},
		},
		lsp = {
			code_actions = {
				prompt = "Code Actions> ",
				async_or_timeout = 5000,
				-- when git-delta is installed use "codeaction_native" for beautiful diffs
				-- try it out with `:FzfLua lsp_code_actions previewer=codeaction_native`
				-- scroll up to `previewers.codeaction{_native}` for more previewer options
				previewer = "codeaction_native",
			},
			symbols = {
				symbol_icons = require("config.ui.kinds").icons,
			},
		},
		git = {
			icons = {
				["M"] = { icon = signs.fzf.git.modified, color = "yellow" },
				["D"] = { icon = signs.fzf.git.removed, color = "red" },
				["A"] = { icon = signs.fzf.git.added, color = "green" },
				["R"] = { icon = signs.fzf.git.renamed, color = "yellow" },
			},
		},
		previewers = {
			builtin = {
				delay = 0, -- Pas de délai pour le preview
				treesitter = { enable = false }, -- Désactiver treesitter si non nécessaire
			},
		},
	})

	vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
	vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "find buffers" })
	vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "find all lsp references" })
	vim.keymap.set("n", "<leader>fG", fzf.git_files, { desc = "find git files" })
	vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "grep words inside files" })
	vim.keymap.set("n", "<leader>fl", fzf.live_grep_resume, { desc = "resume grep" })
	vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "grep string under cursor" })
	vim.keymap.set("n", "<leader>ft", function()
		fzf.grep({ search = "TODO|HACK|PERF|NOTE|FIX|WARN", no_esc = true })
	end, { desc = "Search all todos" })

	vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Toggle fzf diagnostic" })

	-- vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "show documentations" })
	-- vim.keymap.set("n", "<leader>fm", "<cmd>telescope harpoon marks<cr>", { desc = "open harpoon marks" })
	-- vim.keymap.set("n", "<leader>c", function()
	--     require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
	--     end, { desc = "spelling suggestions" })
	-- vim.keymap.set("n", "*", fuzzy_find_under_cursor, { desc = "fuzzy find in file under cursor" })
end

return M
