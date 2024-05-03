local M = {
	"Hoffs/omnisharp-extended-lsp.nvim",
	enabled = true,
	ft = { "cs", "xaml" },
}

local function omnisharp_text_changes_to_text_edits(changes)
	local text_edits = {}
	for _, change in pairs(changes) do
		local textEdit = {
			newText = change.NewText,
			range = {
				start = {
					line = change.StartLine,
					character = change.StartColumn,
				},
				["end"] = {
					line = change.EndLine,
					character = change.EndColumn,
				},
			},
		}

		table.insert(text_edits, textEdit)
	end

	return text_edits
end

local function get_omnisharp_client(buffer)
	local clients = vim.lsp.get_active_clients({ buffer = buffer })
	for _, client in ipairs(clients) do
		if client.name == "omnisharp" then
			return client
		end
	end
end

local function handle(response, buffer)
	if response.err ~= nil then
		return
	end

	if vim.tbl_isempty(response.result) or vim.tbl_isempty(response.result.Changes) then
		return
	end

	local text_edits = omnisharp_text_changes_to_text_edits(response.result.Changes)
	vim.lsp.util.apply_text_edits(text_edits, buffer, "utf-8")
end

local function fix_usings()
	local buffer = vim.api.nvim_get_current_buf()
	local omnisharp_client = get_omnisharp_client(buffer)
	local timeout = 500

	if omnisharp_client == nil then
		return
	end

	local position_params = vim.lsp.util.make_position_params(0, "utf-8")

	local request = {
		Column = position_params.position.character,
		Line = position_params.position.line,
		FileName = vim.uri_to_fname(position_params.textDocument.uri),
		WantsTextChanges = true,
		ApplyTextChanges = false,
	}

	local response = omnisharp_client.request_sync("o#/fixusings", request, timeout, buffer)

	handle(response, buffer)
end

function M.config()
	vim.api.nvim_create_autocmd("LspAttach", {
		pattern = { "*.cs", "*.xaml" },
		callback = function(args)
			vim.keymap.set({ "n" }, "<leader>gd", require("omnisharp_extended").lsp_definition)
			vim.keymap.set({ "n" }, "<leader>gr", require("omnisharp_extended").lsp_references)
			vim.keymap.set({ "n" }, "<leader>gi", require("omnisharp_extended").lsp_implementation)
			vim.keymap.set({ "v", "n" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Open code action menu" })

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = args.buf,
				callback = function()
					if vim.bo[0].filetype == "cs" then
						fix_usings()
					end
				end,
			})
		end,
	})
end

return M
