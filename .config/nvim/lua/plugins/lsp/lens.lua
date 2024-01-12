local M = {
	"VidocqH/lsp-lens.nvim",
	event = "BufEnter",
}

function M.config()
	require("lsp-lens").setup({
		separator = "",
		sections = {
			definition = function(count)
				if count > 1 then
					return " | Def: " .. count
				end
				return ""
			end,
			references = function(count)
				return "Ref: " .. count
			end,
			implements = function(count)
				return "Imp: " .. count .. " | "
			end,
			git_authors = function(latest_author, count)
				return " |   " .. latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
			end,
		},
	})
end

return M