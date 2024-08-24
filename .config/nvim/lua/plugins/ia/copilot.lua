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
					["*"] = true,
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
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
			{
				"<leader>cdf",
				function()
					local ft = vim.bo.filetype

					vim.cmd("normal vaf")

					require("CopilotChat").ask([[
As an expert ]] .. ft .. [[ developer, generate comprehensive and precise documentation for the following function/method. Adhere strictly to ]] .. ft .. [['s official documentation standards and best practices.
Do not include implementation details, nor should you describe how the function works.
Do not include any code snippets or examples.
Do not include any information that is not directly related to the function's purpose and behavior.
Do not describe the function's behavior in terms of the implementation.
Do not assume any prior knowledge of the function's purpose or behavior.
The length of a good documentation is between 50 and 100 words.
The length of a line should not exceed 80 characters.

Do include the following:

1. A concise yet informative description of the function's purpose and behavior.
2. Detailed parameter information:
   - Name
   - Type (be specific, e.g., 'List[int]' instead of just 'List')
   - Description, including any constraints or expected formats
   - Whether the parameter is optional, and if so, its default value
3. Return value:
   - Type (be as specific as possible)
   - Detailed description of what is returned
   - Any special cases or conditions that affect the return value
4. Exceptions or errors:
   - Specific exceptions that may be raised/thrown
   - Conditions under which each exception occurs

Use appropriate ]] .. ft .. [[ specific documentation syntax and formatting.

Others conditions:
 - If the language is lua, use the 3 dashes comment format.

Function signature:
                    ]], {
						selection = require("CopilotChat.select").visual,
						callback = function(response)
							print("BetterDocs callback")
							vim.cmd("normal <C-y>")
						end,
					})
				end,
			},
			{
				"<leader>c",
				mode = { "n", "v" },
				function()
					local ft = vim.bo.filetype
					local prompt = [[
                    /COPILOT_GENERATE
As an expert ]] .. ft .. [[ developer, respond concisely and accurately based only on the provided code selection. Do not provide too much detail or discuss unrelated topics. Follows this rules:
 	1. If you find a mistake in the code, please correct it.
    2. If you think an information can be interesting, please provide it.
    3. If you think the code can be improved, please provide a better version.
    4. Do only respond to the request, do not provide additional information.
Question or request: ]]

					local mode = vim.api.nvim_get_mode().mode
					local header = "Request"
					local is_visual = mode == "v" or mode == "V" or mode == ""

					if is_visual then
						header = header .. " (visual)"
					end

					local question = vim.fn.input(header)
					if question == "" then
						return
					end

					if is_visual then
						require("CopilotChat").ask(
							prompt .. question,
							{ selection = require("CopilotChat.select").visual }
						)
					else
						require("CopilotChat").ask(prompt .. question)
					end
				end,
			},
		},
		opts = function()
			local user = vim.env.USER or "User"
			-- user = user:sub(1, 1):upper() .. user:sub(2)

			return {
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				error_header = "  Error ",
				separator = "───",
				show_folds = false,
				auto_follow_cursor = false,
				-- context = "buffer",

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
				-- 			vim.bo.filetype = "markdown"
				require("cmp").setup.buffer({ enabled = false })
			end, {
				target = "copilot-*",
				desc = "Disable relative number and cmp for CopilotChat",
			})
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		opts = {
			provider = "copilot",
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				"grapp-dev/nui-components.nvim",
				dependencies = {
					"MunifTanjim/nui.nvim",
				},
			},
		},
	},
}
