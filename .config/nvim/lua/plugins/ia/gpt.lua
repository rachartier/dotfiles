local M = {
	"robitx/gp.nvim",
	enabled = true,
}

function M.config()
	require("gp").setup()
	vim.keymap.set("n", "<C-g>t", "<cmd>GpChatToggle popup<cr>", { desc = "Toggle Gpt Popup" })
end

return M
