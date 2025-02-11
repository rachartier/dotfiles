local utils = require("utils")

return {
	"luukvbaal/statuscol.nvim",
	event = { "BufReadPost" },
	-- enabled = false,
	opts = function()
		local builtin = require("statuscol.builtin")

		return {
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
				"Avante",
				"AvanteInput",
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
					condition = {
						function(args)
							local is_num = vim.wo[args.win].number
							local is_relnum = vim.wo[args.win].relativenumber

							return is_num or is_relnum
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

						fillchar = " ",
						-- fillchar = " ",
						maxwidth = 1,
						colwidth = 1,
						fillcharhl = "MiniIndentscopeSymbol",
					},
					condition = {
						function(args)
							local is_num = vim.wo[args.win].number
							local is_relnum = vim.wo[args.win].relativenumber

							return is_num or is_relnum
						end,
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
	end,
}
