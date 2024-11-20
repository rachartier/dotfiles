local utils = require("utils")

-- From: https://github.com/Wansmer/nvim-config/blob/76075092cf6a595f58d6150bb488b8b19f5d625a/lua/modules/status/components.lua#L6
local function number(args)
	local nu = vim.opt.number:get()
	local rnu = vim.opt.relativenumber:get()
	local cur_line = vim.fn.line(".") == vim.v.lnum and vim.v.lnum or vim.v.relnum

	local is_num = vim.wo[args.win].number
	local is_relnum = vim.wo[args.win].relativenumber

	if not is_num and not is_relnum then
		return ""
	end

	-- Repeats the behavior for `vim.opt.numberwidth`
	local width = vim.opt.numberwidth:get() - 3
	local l_count_width = #tostring(vim.api.nvim_buf_line_count(args.buf))
	-- If buffer have more lines than `vim.opt.numberwidth` then use width of line count
	width = width >= l_count_width and width or l_count_width

	local function pad_start(n)
		local len = width - #tostring(n)
		return len < 1 and n or (" "):rep(len) .. n
	end

	local v_hl = ""

	local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
	if mode == "v" then
		local v_range = utils.get_visual_range()
		local is_in_range = vim.v.lnum >= v_range[1] and vim.v.lnum <= v_range[3]

		v_hl = is_in_range and "%#CursorLineNr#" or ""
	end

	if nu and rnu then
		return v_hl .. pad_start(cur_line)
	elseif nu then
		return v_hl .. pad_start(vim.v.lnum)
	elseif rnu then
		return v_hl .. pad_start(vim.v.relnum)
	end

	return pad_start(args.lnum)
end

return {
	"luukvbaal/statuscol.nvim",
	event = { "BufReadPost" },
	enabled = true,
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
					text = {
						number,
						" ",
					},
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
