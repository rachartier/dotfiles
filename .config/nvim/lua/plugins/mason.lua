local M = {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	build = ":MasonBuild",
}

function M.config()
	local U = require("utils")

	require("mason").setup({ ui = { border = U.default_border } })
	require("mason-lspconfig").setup({
		ensure_installed = { "dockerls", "jsonls", "bashls", "pyright", "omnisharp" },
	})
	require("mason-null-ls").setup({
		ensure_installed = {
			"black",
			"flake8",
			"shellcheck",
			"autoflake",
			"autopep8",
			"ruff",
		},
		automatic_installation = true,
		automatic_setup = true,
	})
end

return M
