local icons = require("config.icons")

return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"onsails/lspkind.nvim",
		},
		config = function()
			require("config.diagnostic")
			local on_attach = require("config.lsp.attach").on_attach

			-- require("clangd_extensions.inlay_hints").setup_autocmd()

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			require("mason").setup({ ui = { border = icons.default_border } })

			local languages = require("config.languages")

			local ensure_installed = {}

			for _, server_config in ipairs(languages) do
				if server_config.mason then
					for _, tool in ipairs(server_config.mason) do
						table.insert(ensure_installed, tool)
					end
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				handlers = {
					function(server_name)
						local settings
						local ignore

						for _, server_config in ipairs(languages) do
							if server_config.mason and vim.tbl_contains(server_config.mason, server_name) then
								settings = server_config.lsp_settings
								ignore = server_config.lsp_ignore or false
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

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf

					on_attach(client, bufnr)
				end,
			})

			require("lspconfig.ui.windows").default_options = {
				border = icons.default_border,
			}

			require("config.diagnostic")
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				-- "flake8",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
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
					for _, tool in ipairs(server_config.linter or {}) do
						table.insert(tools, tool)
						print(tool)
					end

					for _, tool in ipairs(server_config.formatter or {}) do
						table.insert(tools, tool)
						print(tool)
					end
				end

				-- get all linters, formatters, & debuggers and merge them into one list

				-- only unique tools
				table.sort(tools)
				tools = vim.fn.uniq(tools)

				-- remove exceptions not to install
				tools = vim.tbl_filter(function(tool)
					return not vim.tbl_contains(dont_install, tool)
				end, tools)
				return tools
			end

			local list_to_install = to_autoinstall_formatter_linter()

			require("mason").setup(opts)

			local to_install_dap = {}
			local to_install_lsp = {}

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

			require("mason-lspconfig").setup({
				ensure_installed = to_install_lsp,
				automatic_installation = true,
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
			local function ensure_installed()
				for _, tool in ipairs(list_to_install) do
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
		end,
	},
}
