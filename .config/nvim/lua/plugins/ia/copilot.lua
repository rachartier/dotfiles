local utils = require("utils")

return {
	-- {
	-- 	"github/copilot.vim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		vim.keymap.set("i", "<C-g>", "", {
	-- 			expr = true,
	-- 			replace_keycodes = false,
	-- 		})
	--
	-- 		-- vim.keymap.set("i", "<C-g>", function()
	-- 		-- 	vim.fn["copilot#Accept"]("")
	-- 		-- 	local ret = vim.fn["copilot#TextQueuedForInsertion"]()
	-- 		--
	-- 		-- 	-- vim.defer_fn(function()
	-- 		-- 	-- 	vim.api.nvim_exec_autocmds("User", {
	-- 		-- 	-- 		pattern = "CustomFormatCopilot",
	-- 		-- 	-- 		modeline = false,
	-- 		-- 	-- 		data = {
	-- 		-- 	-- 			lines_count = lines_count,
	-- 		-- 	-- 		},
	-- 		-- 	-- 	})
	-- 		-- 	-- end, 500)
	-- 		-- 	return ret
	-- 		-- end, { expr = true, silent = true, replace_keycodes = false })
	--
	-- 		vim.keymap.set(
	-- 			"i",
	-- 			"<C-g>",
	-- 			'copilot#Accept("\\<CR>")',
	-- 			{ expr = true, silent = true, replace_keycodes = false }
	-- 		)
	--
	-- 		vim.g.copilot_no_tab_map = true
	--
	-- 		utils.on_event({ "BufEnter" }, function()
	-- 			---@diagnostic disable-next-line: inject-field
	-- 			vim.b.copilot_enabled = false
	-- 		end, {
	-- 			target = {
	-- 				".env",
	-- 				"*secret",
	-- 				"*id_rsa",
	-- 			},
	-- 			desc = "Disable Copilot for sensitive files",
	-- 		})
	-- 	end,
	-- },
	{
		"zbirenbaum/copilot.lua",
		event = "VeryLazy",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<C-g>",
					},
				},
				filetypes = {
					sh = function()
						local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
						if
							string.match(filename, "^%.env.*")
							or string.match(filename, "^%.secret.*")
							or string.match(filename, "^%id_rsa.*")
						then
							return false
						end

						return true
					end,
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		event = "VeryLazy",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim", -- for curl, log wrapper
		},
		keys = {
			{
				"<leader>cc",
				mode = { "n", "v" },
				"<cmd>CopilotChat<CR>",
				desc = "CopilotChat - Help actions",
			},
			{
				"<leader>ch",
				mode = { "n", "v" },
				function()
					local actions = require("CopilotChat.actions")
					-- require("CopilotChat.integrations.telescope").pick(actions.help_actions())
					require("CopilotChat.integrations.telescope").pick(actions.help_actions())
				end,
				desc = "CopilotChat - Help actions",
			},
			-- Show prompts actions with telescope
			{
				"<leader>cp",
				function()
					local actions = require("CopilotChat.actions")
					-- require("CopilotChat.integrations.telescope").pick(actions.prompt_actions({
					-- 	selection = require("CopilotChat.select").visual,
					-- }))
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions({
						selection = require("CopilotChat.select").visual,
					}))
				end,
				mode = { "n", "x", "v" },
				desc = "CopilotChat - Prompt actions",
			},
			-- {
			--     "<leader>cp",
			--     function()
			--         require("utils").copy_visual_selection()
			--         local actions = require("CopilotChat.actions")
			--         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			--     end,
			--     mode = { "x", "v" },
			--     desc = "CopilotChat - Prompt actions",
			-- },
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
		},
		opts = function()
			local user = vim.env.USER or "User"

			return {
				question_header = string.rep("─", #user + 3) .. "\n󰙃  " .. user .. "  ",
				answer_header = "  **Copilot**",
				error_header = "  **Error**",
				separator = " ", -- Separator to use in chat
				show_folds = false,
				auto_follow_cursor = false,
				model = "gpt-4",
				-- context = "buffer",

				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.buffer(source)
				end,

				prompts = {
					BetterNamings = {
						prompt = "/COPILOT_GENERATE Please provide better names for the following variables and/or functions.",
					},
					TestsxUnit = {
						prompt = "/COPILOT_GENERATE Write a set of detailed unit test functions for the following code with the xUnit framework.",
					},
				},
				mappings = {
					show_diff = {
						normal = "cd",
					},
					complete = {
						insert = "",
					},
				},
			}
		end,
		config = function(_, opts)
			local chat = require("CopilotChat")

			require("CopilotChat.integrations.cmp").setup()
			chat.setup(opts)

			vim.keymap.set("n", "<leader>cy", function()
				local buf = vim.api.nvim_get_current_buf()
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

				local start_line = nil
				for i = #lines, 1, -1 do
					if lines[i]:find("Copilot") then
						start_line = i
						break
					end
				end

				if not start_line then
					print("Copilot header not found")
					return
				end

				local code_block = {}
				local in_code_block = false
				for i = start_line, #lines do
					local line = lines[i]
					if line:find("^```") then
						if in_code_block then
							break
						else
							in_code_block = true
						end
					elseif in_code_block then
						table.insert(code_block, line)
					end
				end

				local code_str = table.concat(code_block, "\n")

				if #code_str > 0 then
					vim.fn.setreg("*", code_str)
					vim.fn.setreg("+", code_str)
					print("Code copied to system clipboard.")
				else
					print("No code found.")
				end
			end, { noremap = true, silent = true })

			-- Custom buffer for CopilotChat
			-- vim.api.nvim_create_autocmd("BufEnter", {
			-- 	pattern = "copilot-*",
			-- 	callback = function()
			-- 		vim.opt_local.relativenumber = false
			-- 		vim.opt_local.number = false
			--
			-- 		local ft = vim.bo.filetype
			-- 		if ft == "copilot-chat" then
			-- 			vim.bo.filetype = "markdown"
			-- 		end
			-- 	end,
			-- })
			-- Custom buffer for CopilotChat

			utils.on_event("BufEnter", function()
				vim.opt_local.relativenumber = false
				vim.opt_local.number = false
				vim.opt_local.statuscolumn = " "
				require("cmp").setup.buffer({ enabled = false })
			end, {
				target = "copilot-*",
				desc = "Disable relative number and cmp for CopilotChat",
			})
		end,
	},
}
