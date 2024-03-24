local M = {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		"onsails/lspkind.nvim",
		"neovim/nvim-lspconfig",
	},
	-- event = { "BufEnter" },
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
}

function M.config()
	local lsp = require("lsp-zero")

	local U = require("utils")
	local on_attach = require("config.lsp.attach").on_attach

	lsp.preset("recommended")

	-- require("clangd_extensions.inlay_hints").setup_autocmd()

	local util = require("lspconfig/util")
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	local path = util.path

	local function get_python_path(workspace)
		if vim.env.VIRTUAL_ENV then
			return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
		end

		for _, pattern in ipairs({ "*", ".*" }) do
			local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
			if match ~= "" then
				return path.join(path.dirname(match), "bin", "python")
			end
		end

		return vim.fn.executable("python3") == 1 or vim.fn.executable("python") == 1 or "python"
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local bufnr = args.buf

			on_attach(client, bufnr)
		end,
	})

	require("lspconfig.ui.windows").default_options = {
		border = U.default_border,
	}

	-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
	require("lspconfig")["basedpyright"].setup({
		before_init = function(_, config)
			config.settings.python.pythonPath = get_python_path(config.root_dir)
		end,
		capabilities = capabilities,
		root_dir = util.root_pattern("pyrightconfig.json"),
		settings = {
			pyright = {
				autoImportCompletion = true,
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
	})

	require("lspconfig")["clangd"].setup({
		capabilities = capabilities,
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})

	require("lspconfig")["lua_ls"].setup({
		capabilities = capabilities,
		settings = {
			Lua = {
				hint = {
					enabled = true,
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})

	-- require("lspconfig")["csharp_ls"].setup({
	--     capabilities = capabilities,
	--     on_attach = on_attach,
	-- })
	--
	local pid = vim.fn.getpid()
	local omnisharp_bin = "/home/rachartier/.local/share/nvim/mason/bin/omnisharp"

	require("lspconfig")["omnisharp"].setup({
		cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
		-- handlers = {
		-- 	["textDocument/definition"] = require("omnisharp_extended").handler,
		-- },
		root_dir = util.root_pattern("*.sln"),
		capabilities = capabilities,
		--cmd = { "dotnet", os.getenv("HOME") .. "/.local/omnisharp/run/OmniSharp.dll" },
		analyze_open_documents_only = false,
		enable_decompilation_support = true,
		enable_editorconfig_support = true,
		enable_import_completion = true,
		enable_ms_build_load_projects_on_demand = false,
		enable_roslyn_analyzers = true,
		organize_imports_on_format = true,
		sdk_include_prereleases = false,
		filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "props", "targets" },
	})

	-- require("roslyn").setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach,
	-- })

	local lsp_configurations = require("lspconfig.configs")

	if not lsp_configurations.pico8lsp then
		lsp_configurations.pico8lsp = {
			default_config = {
				cmd = { "pico8-ls", "--stdio" },
				name = "pico8-ls",
				filetypes = { "pico8" },
				root_dir = util.root_pattern("*.p8"),
			},
		}
	end
end

function M.opts()
	local U = require("utils")
	vim.fn.sign_define("DiagnosticSignError", { text = U.diagnostic_signs.error, texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = U.diagnostic_signs.warning, texthl = "DiagnosticSignWarn" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = U.diagnostic_signs.info, texthl = "DiagnosticSignInfo" })
	vim.fn.sign_define("DiagnosticSignHint", { text = U.diagnostic_signs.hint, texthl = "DiagnosticSignHint" })

	vim.diagnostic.config({
		float = { border = U.default_border },
		underline = true,
		update_in_insert = false,
		virtual_lines = {
			highlight_whole_line = false,
			only_current_line = true,
		},
		virtual_text = {
			--   spacing = 4,
			-- source = "if_many",
			prefix = "●",
			-- prefix = "icons",
		},
		-- virtual_text = {
		-- 	prefix = function(diagnostic)
		-- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
		-- 			return U.diagnostic_signs.error
		-- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
		-- 			return U.diagnostic_signs.warning
		-- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
		-- 			return U.diagnostic_signs.info
		-- 		else
		-- 			return U.diagnostic_signs.hint
		-- 		end
		-- 	end,
		-- },
		signs = {
			["WARN"] = U.diagnostic_signs.warning,
			["ERROR"] = U.diagnostic_signs.error,
			["INFO"] = U.diagnostic_signs.info,
			["HINT"] = U.diagnostic_signs.hint,
		},
		severity_sort = true,
	})
end

return M
