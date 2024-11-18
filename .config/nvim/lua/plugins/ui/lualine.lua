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
		"catppuccin/nvim",
		"AndreM222/copilot-lualine",
	},
	event = "VeryLazy",
	priority = 900,
	enabled = true,
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
					"progress",
					separator = { right = "" },
					color = { fg = colors.fg },
					padding = { left = 2, right = 0 },
				},
				{
					"location",
					separator = { right = "" },
					color = { fg = colors.fg },
					padding = { left = 1, right = 0 },
				},
				{
					function()
						if vim.fn.mode():find("[vV]") then
							local ln_beg = vim.fn.line("v")
							local ln_end = vim.fn.line(".")

							local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1

							return "sel: " .. tostring(vim.fn.wordcount().visual_chars) .. " | " .. tostring(lines)
						else
							return ""
						end
					end,
					color = { fg = colors.fg },
					separator = { right = "" },
				},
			},
			lualine_c = {
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
					padding = { left = 3, right = 0 },
					separator = { right = "", left = "" },
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
					padding = { left = 3, right = 1 },
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
					"branch",
					icon = signs.git.branch,
					color = { fg = colors.violet },
					separator = { right = "", left = "" },
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
					-- diff_color = {
					-- 	added = { gui = "bold" },
					-- 	modified = { gui = "bold" },
					-- 	removed = { gui = "bold" },
					-- },
				},
			},
			lualine_z = {
				{
					"filetype",
					color = { bg = colors.pink, fg = colors.bg },
					separator = { right = "", left = "" },
					cond = cond_disable_by_ft,
					icon_only = true,
					colored = false,
					padding = { right = 0, left = 0 },
					condition = conditions.buffer_not_empty,
				},
				{
					"filename",

					padding = { right = 1, left = 0 },
					color = { bg = colors.pink, fg = colors.bg },
					separator = { right = "", left = "" },

					symbols = {
						modified = signs.file.modified, -- Text to show when the file is modified.
						readonly = signs.file.readonly, -- Text to show when the file is non-modifiable or readonly.
						unnamed = signs.file.unnamed, -- Text to show for unnamed buffers.
						newfile = signs.file.created, -- Text to show for newly created file before first write
					},
				},
			},
		}

		local config = {
			options = {
				theme = "auto",
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
