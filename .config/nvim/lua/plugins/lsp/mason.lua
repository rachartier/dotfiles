local M = {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	build = ":MasonUpdate",
}

function M.config()
	local U = require("utils")
	local icons = require("config.icons")

	require("mason").setup({ ui = { border = icons.default_border } })

	local lsp = require("lsp-zero")
	lsp.extend_lspconfig()

	-- require("mason-null-ls").setup({
	-- 	ensure_installed = {
	-- 		"black",
	-- 		"flake8",
	-- 		"shellcheck",
	-- 		"autoflake",
	-- 		"autopep8",
	-- 		"ruff",
	-- 	},
	-- 	automatic_installation = true,
	-- 	automatic_setup = true,
	-- })
	--
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

	require("mason-lspconfig").setup({
		ensure_installed = require("config.lsp").ensure_installed,
	})
end

return M
