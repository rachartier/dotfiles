local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

return {
	"mfussenegger/nvim-dap",
	-- cond = require("config").config_type ~= "minimal",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
		"mfussenegger/nvim-jdtls",
		-- "nvim-neotest/nvim-nio",
		-- "nvim-telescope/telescope-dap.nvim",
	},
	-- priority = 100,
    -- stylua: ignore
	keys = {
        { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
        { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Breakpoint Condition" },
        { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
        { "<leader>da", "<cmd>lua require('dap').continue({ before = get_args })<cr>", desc = "Run with Args" },
        { "<leader>dC", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
        { "<leader>dg", "<cmd>lua require('dap').goto_()<cr>", desc = "Go to Line (No Execute)" },
        { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
        { "<leader>dj", "<cmd>lua require('dap').down()<cr>", desc = "Down" },
        { "<leader>dk", "<cmd>lua require('dap').up()<cr>", desc = "Up" },
        { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "Run Last" },
        { "<leader>do", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
        { "<leader>dO", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
        { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Pause" },
        { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", desc = "Toggle REPL" },
        { "<leader>ds", "<cmd>lua require('dap').session()<cr>", desc = "Session" },
        { "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate" },
        { "<leader>dw", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "Widgets" },
        { "<F5>", "<cmd>lua local continue = function() if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs(nil, { coreclr = { 'cs' } }) end require('dap').continue() end continue()<cr>", desc = "Continue (F5)" },

        { "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", desc = "Eval" },
        {
            "<leader>dI",
            "<cmd>lua require('dap.ui.widgets').hover()<cr>",
            desc = "Variables",
        },
        {
            "<leader>dS",
           	"<cmd>lua require('dap.ui.widgets').scopes()<cr>" ,
            desc = "Scopes",
        },
	},
	config = function()
		-- require("telescope").load_extension("dap")
		-- require("dap.ext.vscode").load_launchjs()

		require("nvim-dap-virtual-text").setup({
			highlight_new_as_changed = true,
		})

		require("dapui").setup({
			icons = {
				collapsed = "▶",
				current_frame = "▶",
				expanded = "▼",
			},
		})

		require("dap-python").setup("python")
		require("dap.ext.vscode").load_launchjs(nil, { netcoredbg = { "cs" } })

		-- dap.configurations.cs = {
		-- 	{
		-- 		type = "coreclr",
		-- 		request = "launch",
		-- 		name = "launch - codageauto",
		-- 		program = "./bin/Debug/net7.0/siemenscodageauto.dll",
		-- 	},
		-- }

		local sign = vim.fn.sign_define

		sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "red" })
		sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "red" })
		sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "red" })
		sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
		sign("DapStopped", { text = "󰧂", texthl = "DapStopped", linehl = "", numhl = "" })

		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}
