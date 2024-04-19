local icons = require("config.icons")

return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"onsails/lspkind.nvim",
		},
		config = function()
			local on_attach = require("config.lsp.attach").on_attach

			-- require("clangd_extensions.inlay_hints").setup_autocmd()

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			require("mason").setup({ ui = { border = icons.default_border } })

			local config_lsp = require("config.lsp").lsps
			require("mason-lspconfig").setup({
				ensure_installed = require("utils").get_table_keys(require("config.lsp").lsps),
				handlers = {
					function(server_name)
						local defined_lsp = config_lsp[server_name]

						-- If the server settings is not defined, then setup the server with the default settings
						if defined_lsp == nil then
							-- auto managed by flutter-tools.nvim
							if server_name == "dartls" then
								return
							end

							require("lspconfig")[server_name].setup({
								capabilities = capabilities,
							})
						else
							if type(config_lsp[server_name]) == "table" then
								defined_lsp.capabilities = capabilities
								require("lspconfig")[server_name].setup(defined_lsp)
							end
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
			local linters = require("config.linter").enabled
			local formatters = require("config.formatter").enabled
			local daps = require("config.dap").ensure_installed
			local extras = require("config").extras

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

			local function to_autoinstall()
				-- get all linters, formatters, & debuggers and merge them into one list
				local linterList = vim.tbl_flatten(vim.tbl_values(linters))
				local formatterList = vim.tbl_flatten(vim.tbl_values(formatters))
				local tools = vim.list_extend(linterList, formatterList)
				vim.list_extend(tools, extras)
				vim.list_extend(tools, daps)

				-- only unique tools
				table.sort(tools)
				tools = vim.fn.uniq(tools)

				-- remove exceptions not to install
				tools = vim.tbl_filter(function(tool)
					return not vim.tbl_contains(dont_install, tool)
				end, tools)
				return tools
			end

			local list_to_install = to_autoinstall()

			require("mason").setup(opts)
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
