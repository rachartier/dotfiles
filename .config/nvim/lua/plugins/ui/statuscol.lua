return {
	"luukvbaal/statuscol.nvim",
	event = { "BufReadPre", "BufNewFile" },
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
			},

			-- Builtin line number string options for ScLn() segment
			thousands = false, -- or line number thousands separator string ("." / ",")
			relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
			-- Custom line number string options for ScLn() segment
			lnumfunc = nil, -- custom function called by ScLn(), should return a string
			reeval = false, -- whether or not the string returned by lnumfunc should be reevaluated
			-- Builtin 'statuscolumn' options
			setopt = true, -- whether to set the 'statuscolumn', providing builtin click actions
			segments = {
				-- { text = { "%C" }, click = "v:lua.ScFa" },
				{
					sign = {
						namespace = { "diagnostic" },
						name = { ".*" },
						auto = false,
					},
					click = "v:lua.ScSa",
				},
				{
					text = { builtin.lnumfunc, " " },
					condition = {
						true,
						true,
						-- function()
						-- 	return vim.wo.number == true or vim.wo.relativenumber == true
						-- end,
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

						fillchar = "▏",
						maxwidth = 1,
						colwidth = 1,
						-- fillcharhl = "GitSignsAdd",
					},
					click = "v:lua.ScSa",
				},
				{
					text = { " " },
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
