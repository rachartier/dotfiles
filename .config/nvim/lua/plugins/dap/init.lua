return {
	"mfussenegger/nvim-dap",
	cond = require("config").config_type ~= "minimal",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-jdtls",
		-- "nvim-telescope/telescope-dap.nvim",
	},
	-- priority = 100,
	keys = {
		"<F9>",
		"<leader>bc",
		"<leader>bl",
		"<leader>br",
		"<leader>ba",
		"<leader>dd",
		"<leader>dt",
		"<leader>dr",
		"<leader>dl",
		"<leader>de",
		"<leader>di",
		"<F5>",
		"<F10>",
		"<F11>",
		"<S-F11>",
		"<leader>ds",
		"<leader>df",
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

		require("dap-python")
		require("dap.ext.vscode").load_launchjs(nil, { netcoredbg = { "cs" } })

		-- dap.configurations.cs = {
		-- 	{
		-- 		type = "coreclr",
		-- 		request = "launch",
		-- 		name = "launch - codageauto",
		-- 		program = "./bin/Debug/net7.0/siemenscodageauto.dll",
		-- 	},
		-- }

		require("plugins.dap.language.cs")

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

		function nnoremap(rhs, lhs, desc)
			vim.keymap.set("n", rhs, lhs, { desc = desc })
		end

		-- nvim-dap
		nnoremap("<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Set breakpoint")
		nnoremap(
			"<leader>bc",
			"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
			"Set conditional breakpoint"
		)
		nnoremap(
			"<leader>bl",
			"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
			"Set log point"
		)
		nnoremap("<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", "Clear breakpoints")
		-- nnoremap("<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", "List breakpoints")

		local continue = function()
			if vim.fn.filereadable(".vscode/launch.json") then
				require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })
			end
			require("dap").continue()
		end

		nnoremap("<F5>", continue, "Continue")
		nnoremap("<F10>", "<cmd>lua require'dap'.step_over()<cr>", "Step over")
		nnoremap("<F11>", "<cmd>lua require'dap'.step_into()<cr>", "Step into")
		nnoremap("<S-F11>", "<cmd>lua require'dap'.step_out()<cr>", "Step out")
		nnoremap("<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect")
		nnoremap("<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", "Terminate")
		nnoremap("<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", "Open REPL")
		nnoremap("<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", "Run last")
		nnoremap("<leader>de", "<cmd>lua require'dapui'.eval()<cr>", "Eval")
		nnoremap("<leader>di", function()
			require("dap.ui.widgets").hover()
		end, "Variables")
		nnoremap("<leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end, "Scopes")
		-- nnoremap("<leader>df", "<cmd>Telescope dap frames<cr>", "List frames")
	end,
}
