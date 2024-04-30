return {
	"nvim-lualine/lualine.nvim",
	dependency = { "nvim-tree/nvim-web-devicons" },
	event = "LazyFile",
	config = function()
		local icons = require("config.icons")

		local colors = require("theme").get_lualine_colors()
		local kirby_colors = {
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

		local default_theme

		if vim.g.neovide then
			-- default_theme = { fg = colors.surface0, bg = colors.mantle }
			default_theme = { fg = colors.surface0, bg = colors.mantle }
		else
			default_theme = { fg = colors.surface0, bg = "None" }
		end

		local config = {
			options = {
				icons_enabled = true,
				disabled_filetypes = { "alpha" },
				globalstatus = true,
				component_separators = "",
				section_separators = "",
				theme = {
					normal = {
						c = default_theme,
						x = default_theme,
					},
					inactive = {
						c = default_theme,
						x = default_theme,
					},
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_v = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left({
			function()
				-- if is_inside_docker then
				-- 	return "▌  "
				-- end
				-- return "▌"

				if is_inside_docker then
					return "  "
				end
				return ""
			end,
			color = { fg = colors.blue },
			padding = 0,
		})

		ins_left({
			function()
				vim.api.nvim_command(
					"hi! LualineMode guifg=" .. kirby_colors[vim.fn.mode()] .. " guibg=" .. default_theme.bg
				)
				return mode_kirby[vim.fn.mode()]
			end,
			color = "LualineMode",
			left_padding = 0,
		})

		ins_left({
			"diagnostics",
			sources = { "nvim_lsp" },
			symbols = icons.signs.diagnostic,
			-- diagnostics_color = {
			--     error = { fg = c.error },
			--     warn = { fg = c.warn },
			--     info = { fg = c.info },
			--     hint = { fg = c.hint },
			-- },
			colored = true,
		})

		ins_left({
			"branch",
			icon = "",
			color = { fg = colors.violet },
		})
		-- ins_left({
		-- 	"diff",
		-- 	colored = true,
		-- 	source = diff_source,
		-- 	symbols = {
		-- 		added = U.signs.git.added,
		-- 		modified = U.signs.git.modified,
		-- 		removed = U.signs.git.removed,
		-- 	},
		-- 	diff_color = {
		-- 		-- added = { gui = "bold" },
		-- 		-- modified = { gui = "bold" },
		-- 		-- removed = { gui = "bold" },
		-- 	},
		-- })

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left({
			function()
				return "%="
			end,
		})

		ins_left({
			"filetype",
			icon_only = true,
			separator = "",
			padding = { right = 0, left = 1 },
			condition = conditions.buffer_not_empty,
		})
		ins_left({
			-- get_current_filename_with_icon,
			"filename",
			condition = conditions.buffer_not_empty,
			color = { fg = colors.fg },
			separator = "",
			padding = { left = 0 },
		})

		-- ins_left({
		-- 	-- Lsp server name .
		-- 	function()
		-- 		local msg = "No Active Lsp"
		-- 		local text_clients = ""
		-- 		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		-- 		local clients = vim.lsp.get_active_clients()
		--
		-- 		if next(clients) == nil then
		-- 			return msg
		-- 		end
		-- 		for _, client in ipairs(clients) do
		-- 			local filetypes = client.config.filetypes
		-- 			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
		-- 				text_clients = text_clients .. client.name .. ", "
		-- 			end
		-- 		end
		-- 		if text_clients ~= "" then
		-- 			return text_clients:sub(1, -3) .. "           "
		-- 		end
		-- 		return msg
		-- 	end,
		-- 	icon = "  LSP:",
		-- 	color = { fg = colors.text, gui = "bold" },
		-- })

		-- Add components to right sections
		-- ins_right({
		--     "o:encoding", -- option component same as &encoding in viml
		--     upper = true, -- I'm not sure why it's upper case either ;)
		--     condition = conditions.hide_in_width,
		--     color = { fg = colors.green },
		-- })
		-- ins_right({
		--     "fileformat",
		--     upper = true,
		--     icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
		--     color = { fg = colors.green },
		-- })

		ins_right({
			require("lazy.status").updates,
			cond = require("lazy.status").has_updates,
			color = { fg = colors.green },
		})

		ins_right({
			function()
				return " "
			end,
			cond = function()
				local ok, clients = pcall(vim.lsp.get_active_clients)

				if not ok then
					return true
				end

				for _, client in ipairs(clients) do
					print(require("utils").dump(client))
					if client.name == "GitHub Copilot" then
						return true
					end
				end

				return false
			end,
			color = { fg = colors.fg },
		})

		ins_right({ "progress", color = { fg = colors.fg } })
		ins_right({ "location", color = { fg = colors.fg } })
		ins_right({
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
		})

		ins_right({
			-- filesize component
			function()
				local function format_file_size(file)
					local size = vim.fn.getfsize(file)
					if size <= 0 then
						return ""
					end
					local sufixes = { "b", "k", "m", "g" }
					local i = 1
					while size > 1024 do
						size = size / 1024
						i = i + 1
					end
					return string.format("%.1f%s", size, sufixes[i])
				end
				local file = vim.fn.expand("%:p")
				if string.len(file) == 0 then
					return ""
				end
				return " " .. format_file_size(file)
			end,
			condition = conditions.buffer_not_empty,
			color = { fg = colors.fg },
		})

		require("lualine").setup(config)
	end,
}
