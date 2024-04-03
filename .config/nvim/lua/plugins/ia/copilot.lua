return {
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
			--             vim.g.copilot_no_tab_map = true;
			-- vim.g.copilot_assume_mapped = true;
			-- vim.g.copilot_tab_fallback = "";
			vim.api.nvim_set_keymap("i", "<M-g>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		end,
	},
	-- {
	--
	-- 	"zbirenbaum/copilot.lua",
	--
	-- 	config = function()
	-- 		require("copilot").setup({
	-- 			panel = {
	-- 				enabled = true,
	-- 				auto_refresh = true,
	-- 			},
	-- 			suggestion = {
	-- 				enabled = true,
	-- 				-- use the built-in keymapping for "accept" (<M-l>)
	-- 				auto_trigger = true,
	-- 				accept = false, -- disable built-in keymapping
	-- 			},
	-- 		})
	--
	-- 		local cmp_status_ok, cmp = pcall(require, "cmp")
	-- 		if cmp_status_ok then
	-- 			cmp.event:on("menu_opened", function()
	-- 				vim.b.copilot_suggestion_hidden = true
	-- 			end)
	--
	-- 			cmp.event:on("menu_closed", function()
	-- 				vim.b.copilot_suggestion_hidden = false
	-- 			end)
	-- 		end
	-- 	end,
	-- },
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			"github/copilot.vim",
			-- "zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim", -- for curl, log wrapper
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
	},
}
