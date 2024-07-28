return {
	"luukvbaal/statuscol.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	enabled = true,
	config = function()
		local builtin = require("statuscol.builtin")
		-- local inside_git_repo

		-- local Job = require("plenary.job")
		-- inside_git_repo = Job:new({
		-- 	command = "git",
		-- 	args = { "rev-parse", "--is-inside-work-tree" },
		-- })
		-- 	:sync()[1]

		local cfg = {
			separator = " ", -- separator between line number and buffer text ("│" or extra " " padding)
			ft_ignore = {
				"dapui_stacks",
				"dapui_breakpoints",
				"dapui_scopes",
				"dapui_watches",
				"dapui_console",
				"dap-repl",
				"oil",
				"Trouble",
				"TelescopePrompt",
			},

			segments = {
				-- { text = { "%C" }, click = "v:lua.ScFa" },
				{
					sign = {
						name = { ".*" },
						text = { ".*" },
						namespace = { ".*" },
						auto = false,
					},
					click = "v:lua.ScSa",
				},
				{
					text = { builtin.lnumfunc, " " },
					sign = {
						auto = true,
					},
					condition = {
						function()
							return vim.wo.number
						end,
						function()
							return vim.wo.number
						end,
					},
					click = "v:lua.ScLa",
				},
				{
					-- condition = {
					-- 	function()
					-- 		return inside_git_repo
					-- 	end,
					-- },
					sign = {
						namespace = { "gitsigns" },
						auto = false,

						-- fillchar = "▏",
						fillchar = " ",
						maxwidth = 1,
						colwidth = 1,
						-- fillcharhl = "GitSignsAdd",
					},
					click = "v:lua.ScSa",
				},
			},
			-- Click actions
			Lnum = builtin.lnum_click,
			FoldPlus = builtin.foldplus_click,
			FoldMinus = builtin.foldminus_click,
			FoldEmpty = builtin.foldempty_click,
			DapBreakpointRejected = builtin.toggle_breakpoint,
			DapBreakpoint = builtin.toggle_breakpoint,
			DapBreakpointCondition = builtin.toggle_breakpoint,
			DiagnosticSignError = builtin.diagnostic_click,
			DiagnosticSignHint = builtin.diagnostic_click,
			DiagnosticSignInfo = builtin.diagnostic_click,
			DiagnosticSignWarn = builtin.diagnostic_click,
			GitSignsTopdelete = builtin.gitsigns_click,
			GitSignsUntracked = builtin.gitsigns_click,
			GitSignsAdd = builtin.gitsigns_click,
			GitSignsChangedelete = builtin.gitsigns_click,
			GitSignsDelete = builtin.gitsigns_click,
		}

		require("statuscol").setup(cfg)
	end,
}
