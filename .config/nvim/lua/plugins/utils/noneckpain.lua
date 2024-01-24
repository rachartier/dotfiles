local M = {
	"shortcuts/no-neck-pain.nvim",
	enabled = false,
}
function M.config()
	require("no-neck-pain").setup({
		disableOnLastBuffer = false,
		autocmds = {
			enableOnVimEnter = true,
		},
		mappings = {
			enabled = true,
			toggle = "<Leader>np",
		},
		buffers = {
			setNames = false,
			colors = {
				blend = -0.3,
			},
			right = {
				enabled = false,
			},
			scratchPad = {
				enabled = true,
				location = "~/.config/nvim/notes/scratchpad/",
			},
			bo = {
				filetype = "md",
			},
		},
		integrations = {
			undotree = {
				-- The position of the tree.
				--- @type "left"|"right"
				position = "left",
			},
		},
	})
end

return M
