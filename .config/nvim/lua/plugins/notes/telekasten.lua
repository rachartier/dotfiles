return {
	"renerocksai/telekasten.nvim",
	cond = require("config").config_type ~= "minimal",
	dependencies = {},
    -- stylua: ignore
    keys = {
        { mode = { "n" }, "<leader>z",  "<cmd>Telekasten panel<CR>",                   { desc = "Show Telekasten panel" } },
        { mode = { "n" }, "<leader>zf", "<cmd>Telekasten find_notes<CR>",              { desc = "Find notes" } },
        { mode = { "n" }, "<leader>zg", "<cmd>Telekasten search_notes<CR>",            { desc = "Search notes" } },
        { mode = { "n" }, "<leader>zd", "<cmd>Telekasten goto_today<CR>",              { desc = "Go to today" } },
        { mode = { "n" }, "<leader>zz", "<cmd>Telekasten follow_link<CR>",             { desc = "Follow link" } },
        { mode = { "n" }, "<leader>zn", "<cmd>Telekasten new_note<CR>",                { desc = "New note" } },
        { mode = { "n" }, "<leader>zb", "<cmd>Telekasten show_backlinks<CR>",          { desc = "Show backlinks" } },
        { mode = { "n" }, "<leader>zI", "<cmd>Telekasten insert_img_link<CR>",         { desc = "Insert image link" } },
        { mode = { "n" }, "<leader>zr", "<cmd>Telekasten rename_note()<CR>",           { desc = "Rename note" } },
        { mode = { "n" }, "<leader>zp", "<cmd>Telekasten preview_img()<CR>",           { desc = "Preview image" } },
        { mode = { "n" }, "<leader>zm", "<cmd>Telekasten browse_media()<CR>",          { desc = "Browse media" } },
        { mode = { "n" }, "<leader>za", "<cmd>Telekasten show_tags()<CR>",             { desc = "Show tags" } },
        { mode = { "n" }, "<leader>zt", "<cmd>Telekasten toggle_todo({ i=true })<CR>", { desc = "Toggle todo" } },
    },
	opts = {
		home = vim.fn.expand("~/.config/nvim/notes"),
		auto_set_filetype = false,
		auto_set_syntax = false,
	},
	config = function(_, opts)
		require("telekasten").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
			end,
		})

		vim.g.vim_markdown_folding_disabled = 1
	end,
}
