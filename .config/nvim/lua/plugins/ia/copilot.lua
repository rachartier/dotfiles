local utils = require("utils")

return {
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
				panel = { enabled = true },
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
					["copilot-chat"] = true,
					["*"] = true,
					["."] = true,
					markdown = true,
				},
				copilot_model = "gpt-4o-copilot",
				server = {
					type = "binary", -- "nodejs" | "binary"
					custom_server_filepath = nil,
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		enabled = true,
		branch = "main",
		build = "make tiktoken",
		dependencies = {
			"zbirenbaum/copilot.lua",
			-- "github/copilot.vim",
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
					-- require("CopilotChat.integrations.telescope").pick(actions.help_actions())
					require("CopilotChat").select_prompt()
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

					require("CopilotChat").select_prompt({
						selection = require("CopilotChat.select").visual,
					})
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
				model = "claude-3.7-sonnet",
				show_folds = false,
				auto_follow_cursor = false,
				debug = false,
				log_level = "error",
				-- context = "buffer",

				selection = function(source)
					return require("CopilotChat.select").visual(source) or ""
				end,

				prompts = {
					Refactor = {
						prompt = "Refactor the following code to improve readability, maintainability, and professionalism while keeping the same functionality. Ensure the code remains simple, clean, and easy to understand. Use clear variable and function names, add meaningful comments where necessary, and follow best coding practices.",
					},
					BetterNamings = {
						prompt = "/COPILOT_GENERATE Provide better names for the following variables and/or functions.",
					},
					TestsxUnit = {
						prompt = "/COPILOT_GENERATE Write a set of detailed unit test functions for the following code with the xUnit framework.",
					},
					AddPEP = {
						prompt = [[
/COPILOT_GENERATE Analyze the selected code and add useful, related Python Enhancement Proposals (PEPs). The PEPs should be directly relevant to the concepts, functions, or constructs used in the code. Ensure the references are accurate and avoid including unrelated PEPs.

Example input:

### Classes in Python
class MyClass:
    def __init__(self, value: int):
        self.value = value

    def increment(self):
        self.value += 1

Output:
:::info
Useful PEPs for this section (not exhaustive):
- [PEP 253 (Subtyping Built-in Types)](https://www.python.org/dev/peps/pep-0253/)
- [PEP 257 (Docstring Conventions)](https://www.python.org/dev/peps/pep-0257/)
- [PEP 526 (Syntax for Variable Annotations)](https://www.python.org/dev/peps/pep-0526/)
- [PEP 3107 (Function Annotations)](https://www.python.org/dev/peps/pep-3107/)
- [PEP 3119 (Introducing Abstract Base Classes)](https://www.python.org/dev/peps/pep-3119/)
:::
                        ]],
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

			-- require("CopilotChat.integrations.cmp").setup()
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
				-- require("cmp").setup.buffer({ enabled = false })
			end, {
				target = "copilot-*",
				desc = "Disable relative number and cmp for CopilotChat",
			})
		end,
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/avante.nvim",
		"yetone/avante.nvim",
		enabled = true,
		event = "VeryLazy",
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- "github/copilot.vim",
			"zbirenbaum/copilot.lua",
			"echasnovski/mini.icons",
			-- {
			-- 	"HakonHarnes/img-clip.nvim",
			-- 	event = "VeryLazy",
			-- 	opts = {
			-- 		default = {
			-- 			embed_image_as_base64 = false,
			-- 			prompt_for_file_name = false,
			-- 			drag_and_drop = {
			-- 				insert_mode = true,
			-- 			},
			-- 			use_absolute_path = true,
			-- 		},
			-- 	},
			-- },
		},
		opts = {
			behaviour = {
				auto_set_keymaps = true,
				auto_suggestions = false,
				enable_cursor_planning_mode = false,
				support_paste_from_clipboard = true,
			},
			provider = "copilot",
			cursor_applying_provider = "copilot",
			copilot = {
				model = "claude-3.7-sonnet",
			},
			web_search_engine = {
				provider = "google", -- tavily, serpapi, searchapi, google or kagi
			},
			hints = { enabled = true },
			windows = {
				---@type "right" | "left" | "top" | "bottom"
				position = "right", -- the position of the sidebar
				wrap = true, -- similar to vim.o.wrap
				width = 30, -- default % based on available width
				sidebar_header = {
					enabled = false, -- true, false to enable/disable the header
					align = "center", -- left, center, right for title
					rounded = true,
				},
				input = {
					prefix = "> ",
					height = 8, -- Height of the input window in vertical layout
				},
				edit = {
					border = "none",
					start_insert = true, -- Start insert mode when opening the edit window
				},
				ask = {
					start_insert = true, -- Start insert mode when opening the ask window
					border = "none",
				},
			},
		},
	},
}
