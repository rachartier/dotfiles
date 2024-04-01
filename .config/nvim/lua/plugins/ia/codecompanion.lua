local M = {
	"olimorris/codecompanion.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- Optional
		{
			"stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
		},
	},
	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionToggle",
		"CodeCompanionChat",
	},
	keys = {
		{ "<Leader>cca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Code Companion Actions" },
		{ "<Leader>cc", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Code Companion Toggle" },
	},
	enabled = true,
}

function M.config()
	local ollama_default = require("codecompanion.adapters").use("ollama", {
		schema = {
			model = {
				order = 1,
				mapping = "parameters",
				type = "enum",
				desc = "ID of the model to use.",
				default = "deepseek-coder:6.7b",
				choices = {
					"dolphin-mixtral:8x7b",
					"deepseek-coder:6.7b",
					"deepseek-coder:33b",
					"mixtral:8x7b",
				},
			},
			temperature = {
				order = 2,
				mapping = "parameters.options",
				type = "number",
				optional = true,
				default = 0.7,
				desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
				validate = function(n)
					return n >= 0 and n <= 2, "Must be between 0 and 2"
				end,
			},
		},
	})
	require("codecompanion").setup({
		adapters = {
			chat = ollama_default,
			inline = ollama_default,
		},
		display = {
			action_palette = {
				width = 95,
				height = 10,
			},
			chat = { -- Options for the chat strategy
				type = "buffer", -- float|buffer
				show_settings = true, -- Show the model settings in the chat buffer?
				show_token_count = true, -- Show the token count for the current chat in the buffer?
				buf_options = { -- Buffer options for the chat buffer
					buflisted = false,
				},
			},
		},
		actions = {
			{
				name = "Special advisor",
				strategy = "chat",
				description = "Get some special GenAI advice",
				opts = {
					modes = { "v" },
					auto_submit = true,
					user_prompt = true,
				},
				prompts = {
					{
						role = "system",
						content = function(context)
							return "I want you to act as a senior "
								.. context.filetype
								.. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
						end,
					},
					{
						role = "user",
						contains_code = true,
						content = function(context)
							local text =
								require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)

							return "I have the following code:\n\n```"
								.. context.filetype
								.. "\n"
								.. text
								.. "\n```\n\n"
						end,
					},
				},
			},
		},
	})
end

return M
