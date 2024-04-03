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
	enabled = false,
}

function M.config()
	local ollama_default = require("codecompanion.adapters").use("ollama", {
		url = "http://192.168.1.160:11434/api/chat",
		schema = {
			model = {
				order = 1,
				mapping = "parameters",
				type = "enum",
				desc = "ID of the model to use.",
				default = "deepseek-coder:6.7b",
				choices = {
					"pxlksr/opencodeinterpreter-ds:6.7b-Q4_K",
					"magicoder:7b",
					"deepseek-coder:6.7b",
					"mixtral:8x7b",
					"mixtral:8x7b-instruct-v0.1-q2_K",
				},
			},
			temperature = {
				order = 2,
				mapping = "parameters.options",
				type = "number",
				optional = true,
				default = 0.1,
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
		strategies = {
			chat = "ollama",
			inline = "ollama",
		},
		display = {
			action_palette = {
				width = 95,
				height = 10,
			},
			chat = { -- Options for the chat strategy
				type = "buffer", -- float|buffer
				show_settings = true, -- Show the model settings in the chat buffer?
				show_token_count = false, -- Show the token count for the current chat in the buffer?
				buf_options = { -- Buffer options for the chat buffer
					buflisted = false,
				},
			},
		},
	})
end

return M
