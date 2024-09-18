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
				changed_instances_count = changed_instances_count + #changed_file.edits
				changed_files_count = changed_files_count + 1
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

function M.make_capabilities()
	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	capabilities.textDocument.completion.completionItem = {
		documentationFormat = { "markdown", "plaintext" },
		snippetSupport = true,
		preselectSupport = true,
		insertReplaceSupport = true,
		labelDetailsSupport = true,
		deprecatedSupport = true,
		commitCharactersSupport = true,
		tagSupport = { valueSet = { 1 } },
		resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		},
	}

	return capabilities
end

function M.on_attach(client, bufnr)
	-- client.server_capabilities.semanticTokensProvider = nil

	-- local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
	-- if client.supports_method("textDocument/inlayHint") then
	--     inlay_hint(bufnr, true)
	-- end

	local wk = require("which-key")
    -- stylua: ignore start
    wk.add({
        {
            mode = "n",
            { "gD",          function() vim.lsp.buf.declaration() end,                  desc = "Go to declaration" },
            { "K",           function() vim.lsp.buf.hover() end,                        desc = "Show hover" },
            { "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,             desc = "Workspace symbol" },
            { "<leader>vd",  function() vim.diagnostic.open_float() end,                desc = "Open diagnostic inside a floating window" },
            { "<leader>rr",  function() vim.lsp.buf.references() end,                   desc = "Find references" },
            { "<leader>rn",  function() M.lsp_rename() end,                             desc = "Rename current symbol" },
            { "gd",          function() vim.lsp.buf.definition() end,                   desc = "Go to definition" },
            { "<leader>gn",  function() vim.diagnostic.jump({ count = 1 }) end,         desc = "Go to next diagnostic" },
            { "<leader>gp",  function() vim.diagnostic.jump({ count = -1 }) end,        desc = "Go to previous diagnostic" },
            -- { "<leader>ca",  function() require("tiny-code-action").code_action()  end, {noremap = true, silent=true}, desc = "Open code action menu" },
        },
        { "<C-h>", function() vim.lsp.buf.signature_help() end, desc = "Help", mode = { "i" } },
    })
    -- vim.keymap.set({ "v", "n" }, "<leader>ca", require("fzf-lua").lsp_code_actions, { desc = "Open code action menu" })

    vim.keymap.set({"n"},  "<leader>ca",  function() require("tiny-code-action").code_action()  end, {noremap = true, silent=true, desc = "Open code action menu"})
    if client.name == "omnisharp" then
        wk.add({
            mode = "n",
            { "<leader>gd", require("omnisharp_extended").lsp_definition, desc = "Omnisharp Go to definition" },
            { "<leader>gr", require("omnisharp_extended").lsp_references, desc = "Omnisharp Find references" },
            { "<leader>gi", require("omnisharp_extended").lsp_implementation, desc = "Omnisharp Go to implementation" },
        })
    end

	-- stylua: ignore end
end

return M
