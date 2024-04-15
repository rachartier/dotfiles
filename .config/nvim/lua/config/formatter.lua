local M = {}

local linter_config = require("utils").linter_config_folder

M.enabled = {
	json = { "fixjson", "typos" },
	jsonc = { "fixjson", "typos" },
	lua = { "stylua", "ast-grep", "typos" },
	python = { "ruff", "ruff_format", "ruff_fix", "typos" },
	yaml = { "typos" },
	html = { { "prettier" }, "typos" },
	htmldjango = { { "prettier" }, "typos" },
	dockerfile = { "hadolint", "typos" },
	markdown = {
		"markdown-toc",
		"markdownlint",
		"injected",
	},
	c = { "clang-format", "typos" },
	cs = { "csharpier", "typos" },
	css = { "stylelint", "prettier", "typos" },
	sh = { "shellcheck", "shfmt", "typos" },
	["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
}

M.by_ft_options = {
	markdownlint = {
		prepend_args = {
			"--config=" .. linter_config .. "/markdownlint.yaml",
		},
	},
	autoflake = {
		prepend_args = {
			"--remove-all-unused-imports",
			"--remove-unused-variables",
		},
	},
	black = {
		prepend_args = {
			"--line-length",
			"400",
		},
	},
	csharpier = {
		command = "dotnet-csharpier",
		args = { "--write-stdout" },
	},

	["clang-format"] = {
		command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clang-format",
		inherit = false,
		args = {
			"--style=file:" .. linter_config .. "/clang-format",
			"$FILENAME",
		},
	},
}

return M
