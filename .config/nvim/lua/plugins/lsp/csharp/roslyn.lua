local utils = require("utils")

local function fix_usings()
	local bufnr = vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({ name = "roslyn" })
	if not clients or vim.tbl_isempty(clients) then
		vim.notify("Couldn't find client", vim.log.levels.ERROR, { title = "Roslyn" })
		return
	end

	local client = clients[1]
	local action = {
		title = "Remove unnecessary usings",
		kind = "quickfix",
		data = {
			TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
			CodeActionPath = { "Remove unnecessary usings" },
			CustomTags = { "RemoveUnnecessaryImports" },
			NestedCodeActions = {},
			Range = {
				["end"] = {
					character = 0,
					line = 0,
				},
				start = {
					character = 0,
					line = 0,
				},
			},
			UniqueIdentifier = "Remove unnecessary usings",
		},
	}

	client.request("codeAction/resolve", action, function(err, resolved_action)
		if err then
			vim.notify("Fix using directives failed", vim.log.levels.ERROR, { title = "Roslyn" })
			return
		end
		vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
	end)
end

return {
	"seblj/roslyn.nvim",
	ft = { "cs", "vb" },
	opts = {
		config = {
			-- Here you can pass in any options that that you would like to pass to `vim.lsp.start`
			-- The only options that I explicitly override are, which means won't have any effect of setting here are:
			--     - `name`
			--     - `cmd`
			--     - `root_dir`
			--     - `on_init`
		},
		exe = {
			"dotnet",
			vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
		},
		-- NOTE: Set `filewatching` to false if you experience performance problems.
		-- Defaults to true, since turning it off is a hack.
		-- If you notice that the server is _super_ slow, it is probably because of file watching
		-- I noticed that neovim became super unresponsive on some large codebases, and that was because
		-- it schedules the file watching on the event loop.
		-- This issue went away by disabling that capability. However, roslyn will fallback to its own
		-- file watching, which can make the server super slow to initialize.
		-- Setting this option to false will indicate to the server that neovim will do the file watching.
		-- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
		-- a lot faster to initialize.
		filewatching = true,
		on_attach = require("config.lsp.attach").on_attach,
	},
	config = function(_, opts)
		require("roslyn").setup(opts)
		-- vim.api.nvim_create_autocmd("LspAttach", {
		-- 	pattern = { "*.cs", "*.xaml" },
		-- 	callback = function()
		-- 		utils.on_event("BufWritePre", function()
		-- 			if vim.bo[0].filetype == "cs" then
		-- 				fix_usings()
		-- 			end
		-- 		end, { desc = "Fix usings on save" })
		-- 	end,
		-- })
	end,
}
