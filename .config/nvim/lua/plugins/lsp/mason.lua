local M = {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	priority = 50,
	build = ":MasonUpdate",
}

function M.config()
	local U = require("utils")
	local icons = require("config.icons")

	require("mason").setup({ ui = { border = icons.default_border } })

	local lsp = require("lsp-zero")
	lsp.extend_lspconfig()

	local lspconfig = require("lspconfig")
	local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
	local on_attach = require("config.lsp.attach").on_attach
	local config_lsp = require("config.lsp").lsps

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			if server_name == "omnisharp" then
				return
			end

			if type(config_lsp[server_name]) == "string" then
				lspconfig[server_name].setup({
					capabilities = lsp_capabilities,
					on_attach = on_attach,
				})
			end
		end,
	})

	require("mason-nvim-dap").setup({
		automatic_installation = true,
		handlers = {},
	})

	local linters = require("config.linter").enabled
	local formatters = require("config.formatter").enabled
	local lsps = require("config.lsp").ensure_installed
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
		vim.list_extend(tools, lsps)
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

	local registry = require("mason-registry")
	registry.refresh(function()
		for _, name in pairs(to_autoinstall()) do
			local package = registry.get_package(name)
			if not registry.is_installed(name) then
				package:install()
			else
				package:check_new_version(function(success, result_or_err)
					if success then
						package:install({ version = result_or_err.latest_version })
					end
				end)
			end
		end
	end)
end

return M
