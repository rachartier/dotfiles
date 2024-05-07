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
		"<leader>tt",
		-- { "<Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
		-- { "<S-Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
	},
	enabled = false,
}

function M.config()
	local fzf = require("fzf-lua")

	fzf.setup({
		winopts = {
			border = require("config.icons").default_border,
			width = 0.6,
			height = 0.6,
			row = 0.5, -- window row position (0=top, 1=bottom)
			col = 0.5,
			preview = {
				flip_columns = 200,
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
			ignore_patterns = { "*.gif" },
		},
		diagnostics = {
			winopts = {
				preview = { hidden = "hidden" },
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

	vim.keymap.set("n", "<leader>tt", fzf.diagnostics_workspace, { desc = "Toggle fzf diagnostic" })

	-- vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "show documentations" })
	-- vim.keymap.set("n", "<leader>fm", "<cmd>telescope harpoon marks<cr>", { desc = "open harpoon marks" })
	-- vim.keymap.set("n", "<leader>c", function()
	--     require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
	--     end, { desc = "spelling suggestions" })
	-- vim.keymap.set("n", "*", fuzzy_find_under_cursor, { desc = "fuzzy find in file under cursor" })
end

return M
