local function get_vlinecount_str()
	local raw_count = vim.fn.line(".") - vim.fn.line("v")
	raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

	return math.abs(raw_count)
end

local function get_scrollbar()
	local sbar_chars = {
		"▔",
		"🮂",
		"🬂",
		"🮃",
		"▀",
		"▄",
		"▃",
		"🬭",
		"▂",
		"▁",
	}

	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_line_count(0)

	local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
	local sbar = string.rep(sbar_chars[i], 1)

	return sbar
end

local function get_lualine_colors()
	local c = require("catppuccin.palettes").get_palette(vim.g.catppuccin_flavour)

	local lualine_colors = {
		-- bg = "#232639", --c.mantle,
		-- bg = U.lighten(c.base, 0.99),
		-- bg = c.mantle,
		bg = c.surface0,
		fg = c.subtext0,
		surface0 = c.surface0,
		yellow = c.yellow,
		flamingo = c.flamingo,
		cyan = c.sapphire,
		darkblue = c.mantle,
		green = c.green,
		orange = c.peach,
		violet = c.lavender,
		mauve = c.mauve,
		blue = c.blue,
		red = c.red,
	}

	return vim.tbl_extend("force", lualine_colors, c)
end

local function get_kirby_colors()
	local colors = get_lualine_colors()

	return {
		n = colors.red,
		i = colors.green,
		v = colors.blue,
		[""] = colors.blue,
		V = colors.blue,
		c = colors.mauve,
		no = colors.red,
		s = colors.orange,
		S = colors.orange,
		[""] = colors.orange,
		ic = colors.yellow,
		R = colors.violet,
		Rv = colors.violet,
		cv = colors.red,
		ce = colors.red,
		r = colors.cyan,
		rm = colors.cyan,
		["r?"] = colors.cyan,
		["!"] = colors.red,
		t = colors.red,
	}
end

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local function cond_disable_by_ft()
	local not_empty = conditions.buffer_not_empty()
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })

	local filetype_to_ignore = {
		"terminal",
		"help",
		"alpha",
		"dashboard",
		"neo-tree",
		"Trouble",
		"trouble",
		"lazy",
		"mason",
		"notify",
		"toggleterm",
		"dapui_stacks",
		"toggleterm",
		"lazyterm",
		"fzf",
	}

	if vim.tbl_contains(filetype_to_ignore, filetype) then
		return false
	end

	return not_empty
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"AndreM222/copilot-lualine",
	},
	event = "VeryLazy",
	-- priority = 900,
	enabled = vim.env.TMUX_NEOGIT_POPUP == nil,
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		local signs = require("config.ui.signs")
		local colors = get_lualine_colors()

		local kirby_default = "(>*-*)>"
		local mode_kirby = {
			n = "<(•ᴗ•)>",
			i = "<(•o•)>",
			v = "(v•-•)v",
			[""] = "(v•-•)>",
			V = "(>•-•)>",
			c = kirby_default,
			no = "<(•ᴗ•)>",
			s = kirby_default,
			S = kirby_default,
			[""] = kirby_default,
			ic = kirby_default,
			R = kirby_default,
			Rv = kirby_default,
			cv = "<(•ᴗ•)>",
			ce = "<(•ᴗ•)>",
			r = kirby_default,
			rm = kirby_default,
			["r?"] = kirby_default,
			["!"] = "<(•ᴗ•)>",
			t = "<(•ᴗ•)>",
		}

		local is_inside_docker = false

		local Job = require("plenary.job")
		Job:new({
			command = os.getenv("HOME") .. "/.config/scripts/is_inside_docker.sh",
			on_stdout = function(_, data)
				if data == "1" then
					is_inside_docker = true
				end
			end,
		}):start()

		local sections = {
			lualine_a = {
				{
					"mode",
					-- icons_enabled = true,
					fmt = function()
						return mode_kirby[vim.fn.mode()] or vim.api.nvim_get_mode().mode
					end,
					separator = { right = "" },
					padding = { left = 1, right = 0 },
				},
			},
			lualine_b = {
				{
					"filetype",
					color = { fg = colors.overlay1 },
					separator = { right = "", left = "" },
					cond = cond_disable_by_ft,
					icon_only = true,
					colored = false,
					padding = { right = 0, left = 2 },
				},
				{
					"filename",

					padding = { right = 1, left = 0 },
					color = { fg = colors.overlay1 },
					separator = { right = "", left = "" },

					symbols = {
						modified = signs.file.modified, -- Text to show when the file is modified.
						readonly = signs.file.readonly, -- Text to show when the file is non-modifiable or readonly.
						unnamed = signs.file.unnamed, -- Text to show for unnamed buffers.
						newfile = signs.file.created, -- Text to show for newly created file before first write
					},
				},
			},
			lualine_c = {
				{
					"branch",
					icon = signs.git.branch,
					color = { fg = colors.violet },
					separator = { right = "", left = "" },
					padding = { left = 2, right = 1 },
				},
				{
					"diff",
					colored = true,
					source = diff_source,
					symbols = {
						added = signs.git.added,
						modified = signs.git.modified,
						removed = signs.git.removed,
					},
					separator = { right = "", left = "" },
					-- diff_color = {
					-- 	added = { gui = "bold" },
					-- 	modified = { gui = "bold" },
					-- 	removed = { gui = "bold" },
					-- },
				},
				{
					function()
						local diags = vim.diagnostic.get(0)

						if #diags > 0 then
							return "|"
						end
						return ""
					end,
					cond = conditions.check_git_workspace,
					separator = { right = "", left = "" },
					color = { bg = colors.mantle, fg = colors.overlay0 },
				},
				{
					"diagnostics",
					sources = { "nvim_lsp" },
					symbols = signs.full_diagnostic,
					-- diagnostics_color = {
					-- 	error = { fg = c.error },
					-- 	warn = { fg = c.warn },
					-- 	info = { fg = c.info },
					-- 	hint = { fg = c.hint },
					-- },
					colored = true,
					padding = { left = 1, right = 1 },
					color = { bg = colors.mantle, fg = colors.subtext0 },
				},
			},
			lualine_x = {
				{
					require("lazy.status").updates,
					cond = require("lazy.status").has_updates,
					padding = { left = 1, right = 2 },
					color = { fg = colors.green },
					separator = { right = "" },
				},
				{
					"copilot",
					symbols = {
						status = {
							hl = {
								enabled = colors.green,
								sleep = colors.fg,
								disabled = colors.red,
								warning = colors.yellow,
								unknown = colors.red,
							},
						},
					},
					show_colors = true,
					show_loading = false,
					padding = { left = 1, right = is_inside_docker and 1 or 2 },
					separator = { right = "" },
				},
				-- {
				-- 	function()
				-- 		local ok, copilot_enabled = pcall(vim.api.nvim_buf_get_var, 0, "copilot_enabled")
				--
				-- 		if ok and copilot_enabled then
				-- 			return signs.others.copilot
				-- 		end
				--
				-- 		return signs.others.copilot_disabled
				-- 	end,
				-- 	-- cond = cond_disable_by_ft,
				-- 	color = { fg = colors.fg },
				-- 	separator = { right = "" },
				-- 	padding = { left = 1, right = 2 },
				-- },
				{
					function()
						if is_inside_docker then
							return " "
						end
						return ""
					end,
					separator = { right = "" },
					color = { fg = colors.blue },
					padding = { left = 1, right = 2 },
				},
				{
					function()
						return " "
					end,
					separator = { right = "" },
					padding = { left = 0, right = 0 },
				},
			},
			lualine_y = {
				{
					function()
						local msg = " No Active Lsp"
						local text_clients = ""

						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if next(clients) == nil then
							return msg
						end
						for _, client in ipairs(clients) do
							if client.name ~= "copilot" then
								text_clients = text_clients .. client.name .. ", "
							end
						end
						if text_clients ~= "" then
							return text_clients:sub(1, -3)
						end
						return msg
					end,
					icon = "",
					color = { fg = colors.overlay1 },
					padding = { left = 1, right = 2 },
					separator = { right = "", left = "" },
				},
			},
			lualine_z = {
				-- {
				-- 	"progress",
				-- 	separator = { left = "" },
				-- 	color = { fg = colors.base },
				-- 	padding = { left = 1, right = 0 },
				-- 	cond = function()
				-- 		local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				-- 		return not vim.tbl_contains(vim.g.noncode_ft, ft)
				-- 	end,
				-- },
				{
					"location",
					separator = { left = "", right = "" },
					color = { fg = colors.base },
					padding = { left = 1, right = 0 },
					cond = function()
						local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
						return not vim.tbl_contains(vim.g.noncode_ft, ft)
					end,
				},
				-- {
				-- 	function()
				-- 		if vim.fn.mode():find("[vV]") then
				-- 			local ln_beg = vim.fn.line("v")
				-- 			local ln_end = vim.fn.line(".")
				--
				-- 			local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1
				--
				-- 			return "sel: " .. tostring(vim.fn.wordcount().visual_chars) .. " | " .. tostring(lines)
				-- 		else
				-- 			return ""
				-- 		end
				-- 	end,
				-- 	color = { fg = colors.base },
				-- 	separator = { left = "" },
				-- },
				{
					function()
						local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
						local lines = vim.api.nvim_buf_line_count(0)

						local wc_table = vim.fn.wordcount()

						if wc_table.visual_words and wc_table.visual_chars then
							return table.concat({
								"‹› ",
								get_vlinecount_str(),
								" lines  ",
								wc_table.visual_words,
								" words  ",
								wc_table.visual_chars,
								" chars ",
							})
						end

						if vim.tbl_contains(vim.g.noncode_ft, ft) then
							return table.concat({
								lines,
								" lines  ",
								wc_table.words,
								" words ",
							})
						end

						return ""
					end,
					separator = { left = "" },
					padding = { left = 1, right = 0 },
				},
				{
					function()
						return get_scrollbar()
					end,
					separator = { left = "" },
					color = { fg = colors.surface0 },
					padding = { left = 1, right = 0 },
				},
			},
		}

		local theme = require("lualine.themes.catppuccin")

		theme.normal.c.bg = colors.mantle

		local config = {
			extensions = {
				"lazy",
				"neo-tree",
				"mason",
			},
			options = {
				theme = theme,
				disabled_filetypes = { statusline = { "alpha", "snacks_dashboard" } },
				icons_enabled = true,
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- section_separators = "",
			},
			sections = sections,
			inactive_sections = sections,
		}

		-- ins_left()

		return config
	end,

	config = function(_, opts)
		require("lualine").setup(opts)
	end,
}
