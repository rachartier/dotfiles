local M = {}

M.lsp_rename = function()
	local curr_name = vim.fn.expand("<cword>")
	local value = vim.fn.input("LSP Rename: ", curr_name)
	local lsp_params = vim.lsp.util.make_position_params()

	if not value or #value == 0 or curr_name == value then
		return
	end

	-- request lsp rename
	lsp_params.newName = value
	vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
		if not res then
			return
		end

		-- apply renames
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

		-- print renames
		local changed_files_count = 0
		local changed_instances_count = 0

		if res.documentChanges then
			for _, changed_file in pairs(res.documentChanges) do
				changed_files_count = changed_files_count + 1
				changed_instances_count = changed_instances_count + #changed_file.edits
			end
		elseif res.changes then
			for _, changed_file in pairs(res.changes) do
				changed_instances_count = changed_instances_count + #changed_file
				changed_files_count = changed_files_count + 1
			end
		end

		-- compose the right print message
		require("notify")(
			string.format(
				"Renamed %s instance%s in %s file%s.",
				changed_instances_count,
				changed_instances_count == 1 and "" or "s",
				changed_files_count,
				changed_files_count == 1 and "" or "s"
			)
		)

		vim.cmd("silent! wa")
	end)
end

M.on_attach = function(client, bufnr)
	-- client.server_capabilities.semanticTokensProvider = nil

	local bufopts = { buffer = bufnr, remap = false }

	-- local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
	-- if client.supports_method("textDocument/inlayHint") then
	--     inlay_hint(bufnr, true)
	-- end

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, bufopts)
	vim.keymap.set(
		"n",
		"<leader>vd",
		vim.diagnostic.open_float,
		bufopts,
		{ desc = "Open diagnostic inside a floating window." }
	)
	vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, bufopts, { desc = "Go to next diagnostic" })
	vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, bufopts, { desc = "Go to previous diagnostic" })
	vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, bufopts, { desc = "Find references" })

	if client.name == "omnisharp" then
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts, { desc = "Open code action menu" })
		-- vim.keymap.set("n", "gd", require("omnisharp_extended").lsp_definitions, bufopts)
		vim.keymap.set("n", "gd", require("csharp").go_to_definition, bufopts)
	else
		vim.keymap.set(
			{ "v", "n" },
			"<leader>ca",
			require("actions-preview").code_actions,
			{ desc = "Open code action menu" }
		)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	end

	vim.keymap.set("n", "<leader>rn", function()
		M.lsp_rename()
	end, bufopts, { desc = "Rename current symbol" })

	vim.keymap.set(
		"n",
		"<leader>e",
		"<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
		{ desc = "Show line diagnostics" }
	)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, bufopts, { desc = "Help" })

	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.goto_prev({ float = true })
	end)

	vim.keymap.set("n", "<leader>dn", function()
		vim.diagnostic.goto_prev({ float = false })
	end)
	vim.keymap.set("n", "<leader>dp", function()
		vim.diagnostic.goto_next({ float = false })
	end)
end

return M
