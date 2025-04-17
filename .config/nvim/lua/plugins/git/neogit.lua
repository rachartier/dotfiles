return {
	"NeogitOrg/neogit",
	cmd = "Neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
	},
	opts = {
		graph_style = "unicode",
		process_spinner = true,
		signs = {
			section = { "", "" },
			item = { "", "" },
			hunk = { "", "" },
		},
		integrations = {
			diffview = true,
		},
	},
	config = function(_, opts)
		require("neogit").setup(opts)

		if vim.env.TMUX_NEOGIT_POPUP == "1" then
			local function is_buffer_no_name(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				local name = vim.api.nvim_buf_get_name(bufnr)
				local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })

				return name == "" and (buftype == "" or buftype == "acwrite")
			end

			vim.defer_fn(function()
				require("utils").on_event("BufEnter", function()
					local bufnr = vim.api.nvim_get_current_buf()
					print("bufnr", bufnr)
					if is_buffer_no_name(bufnr) then
						print("is_buffer_no_name")
						vim.cmd("qall!")
					end
				end)
			end, 100)
		end
	end,
}
