local M = {}

M.lsps = {
	"lua_ls",
	"dockerls",
	"jsonls",
	"bashls",
	"pyright",
	"omnisharp",
	-- "clangd",
}

M.linters = {
	lua = { "selene" },
	sh = { "shellcheck" },
	markdown = { "markdownlint", "vale" },
	yaml = { "yamllint" },
	python = { "pylint" },
	gitcommit = {},
	json = {},
	toml = {},
}

M.formatters = {
	json = { "biome" },
	jsonc = { "biome" },
	lua = { "stylua", "ast-grep" },
	python = { "black" },
	yaml = { "prettier" },
	html = { "prettier" },
	markdown = {
		"markdown-toc",
		"markdownlint",
		"injected",
	},
	css = { "stylelint", "prettier" },
	sh = { "shellcheck", "shfmt" },
	["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
	["*"] = { "typos" },
}

M.extras = {
	"debugpy",
	"ruff",
}

return M
