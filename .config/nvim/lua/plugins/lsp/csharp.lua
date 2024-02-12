local M = {
	"iabdelkareem/csharp.nvim",
	dependencies = {
		"williamboman/mason.nvim", -- Required, automatically installs omnisharp
		"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
	},
}

function M.config()
	require("csharp").setup()

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
end

return M
