local icons = require("config.icons")
local utils = require("utils")

return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"onsails/lspkind.nvim",
		},
		config = function()
			vim.lsp.set_log_level("debug")

			local on_attach = require("config.lsp.attach").on_attach
			-- require("clangd_extensions.inlay_hints").setup_autocmd()

			utils.on_event("LspAttach", function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf

				-- client.server_capabilities.semanticTokensProvider = nil
				if client.name == "GitHub Copilot" then
					return
				end

				on_attach(client, bufnr)
			end, {
				desc = "LSP Attach",
			})

			require("lspconfig.ui.windows").default_options = {
				border = icons.default_border,
			}

			require("config.diagnostic")
		end,
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason-nvim-dap.nvim",
		},
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				-- "flake8",
			},
			ui = {
				icons = {
					package_pending = " ",
					package_installed = "󰄳 ",
					package_uninstalled = " ",
				},
				border = icons.default_border,
			},
			keymaps = {
				toggle_server_expand = "<CR>",
				install_server = "i",
				update_server = "u",
				check_server_version = "c",
				update_all_servers = "U",
				check_outdated_servers = "C",
				uninstall_server = "X",
				cancel_installation = "<C-c>",
			},
		},
		config = function(_, opts)
			vim.lsp.set_log_level("off") -- vim.lsp.set_log_level("debug")
			require("mason").setup(opts)

			local dont_install = {
				-- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
				"stylelint",
				-- not real formatters, but pseudo-formatters from conform.nvim
				"trim_whitespace",
				"trim_newlines",
				"squeeze_blanks",
				"injected",
				"ruff_fix",
				"ruff_format",
			}

			local server_settings = require("config.languages")

			local function to_autoinstall_formatter_linter()
				local tools = {}

				for _, server_config in ipairs(server_settings) do
					for tool, tool_name in pairs(server_config.linter or {}) do
						if type(tool_name) == "table" then
							table.insert(tools, tool)
						else
							table.insert(tools, tool_name)
						end
					end

					for tool, tool_name in pairs(server_config.formatter or {}) do
						if type(tool_name) == "table" then
							table.insert(tools, tool)
						else
							table.insert(tools, tool_name)
						end
					end
				end

				-- only unique tools
				table.sort(tools)
				local unique_tools = vim.fn.uniq(tools)

				-- remove exceptions not to install
				local filtered_tools = vim.tbl_filter(function(tool)
					return not vim.tbl_contains(dont_install, tool)
				end, unique_tools)
				return filtered_tools
			end

			local to_install_dap = {}
			local to_install_lsp = {}

			if require("config").config_type ~= "minimal" then
				for _, server_config in ipairs(server_settings) do
					if server_config.dap then
						for _, tool in ipairs(server_config.dap) do
							table.insert(to_install_dap, tool)
						end
					end
					if server_config.mason then
						for _, tool in ipairs(server_config.mason) do
							table.insert(to_install_lsp, tool)
						end
					end
				end

				require("mason-nvim-dap").setup({
					ensure_installed = to_install_dap,
					automatic_installation = true,
				})
			end

			local capabilities = require("config.lsp.attach").make_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = to_install_lsp,
				handlers = {
					function(server_name)
						local settings
						local ignore

						for _, config in ipairs(server_settings) do
							if config.mason and vim.tbl_contains(config.mason, server_name) then
								settings = config.lsp_settings
								ignore = config.lsp_ignore or false
							end
						end

						if ignore then
							return
						end

						if settings then
							settings.capabilities = capabilities
							require("lspconfig")[server_name].setup(settings)
						else
							-- auto managed by flutter-tools.nvim
							if server_name == "dartls" then
								return
							end

							require("lspconfig")[server_name].setup({
								capabilities = capabilities,
							})
						end
					end,
				},
			})

			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			if require("config").config_type ~= "minimal" then
				local function ensure_installed()
					for _, tool in ipairs(to_autoinstall_formatter_linter()) do
						local p = mr.get_package(tool)
						if not p:is_installed() then
							p:install()
						end
					end
				end

				if mr.refresh then
					mr.refresh(ensure_installed)
				else
					ensure_installed()
				end
			end
		end,
	},
}
