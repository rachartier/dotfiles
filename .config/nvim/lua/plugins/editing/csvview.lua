return {
	"hat0uma/csvview.nvim",
	event = "VeryLazy",
	ft = "csv",
	cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	opts = {
		view = {
			display_mode = "border",
		},
		keymaps = {
			-- Excel-like navigation:
			-- Use <Tab> and <S-Tab> to move horizontally between fields.
			-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
			-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
			jump_next_field_end = { "<C-Right>", mode = { "n", "v" } },
			jump_prev_field_end = { "<C-Left>", mode = { "n", "v" } },
			jump_next_row = { "<Enter>", mode = { "n", "v" } },
			jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
		},
	},
	config = function(_, opts)
		require("csvview").setup(opts)

		require("utils").on_event("BufEnter", function()
			vim.cmd("CsvViewEnable")
		end, { desc = "Enable CSVView", target = "*.csv" })
	end,
}
