return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	keys = {
		{
			"<leader>ch",
			mode = { "n", "v" },
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.help_actions())
			end,
			desc = "CopilotChat - Help actions",
		},
		-- Show prompts actions with telescope
		{
			"<leader>cp",
			mode = { "n", "v" },
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end,
			desc = "CopilotChat - Prompt actions",
		},
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
	opts = {
		-- See Configuration section for rest
		prompts = {
			TestsxUnit = {
				prompt = "/COPILOT_TESTS Write a set of detailed unit test functions for the code above with the xUnit framework.",
			},
		},
	},
}
