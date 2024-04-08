local M = {
	"iabdelkareem/csharp.nvim",
	dependencies = {
		"williamboman/mason.nvim", -- Required, automatically installs omnisharp
		"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
	},
	ft = { "cs", "xaml" },
	priority = 50,
	enabled = false,
}

function M.config()
	require("csharp").setup({
		lsp = {
			on_attach = require("config.lsp.attach").on_attach,
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		},
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = args.buf,
				callback = function()
					-- If the file is C# then run fix usings
					if vim.bo[0].filetype == "cs" then
						require("csharp").fix_usings()
					end
				end,
			})
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client.name ~= "omnisharp" then
				return
			end

			require("config.lsp.attach").on_attach()

			vim.keymap.set(
				"n",
				"gd",
				require("csharp").go_to_definition,
				{ silent = true, nowait = true, noremap = true, desc = "Go to Definition", buffer = bufnr }
			)

			vim.keymap.set("n", "<leader>cr", require("csharp").run_project, { desc = "Run csharp project" })
			vim.keymap.set("n", "<leader>cd", require("csharp").debug_project, { desc = "Debug csharp project" })

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Open code action menu" })
		end,
	})
end

return M
