local M = {
	"monaqa/dial.nvim",
	keys = {
		{ mode = { "n", "v" }, "<C-a>", "<cmd>DialIncrement<cr>", desc = "Increment" },
		{ mode = { "n", "v" }, "<C-x>", "<cmd>DialDecrement<cr>", desc = "Decrement" },
	},
}

function M.config()
	local augend = require("dial.augend")
	require("dial.config").augends:register_group({
		default = {
			augend.integer.alias.hex,
			augend.integer.alias.decimal_int,
			augend.date.alias["%Y/%m/%d"],
			augend.date.alias["%Y-%m-%d"],
			augend.date.alias["%d/%m/%y"],
			augend.constant.alias.bool,
			augend.constant.alias.alpha,
			augend.constant.alias.Alpha,
			augend.semver.alias.semver,
			augend.constant.new({
				elements = { "False", "True" },
				word = true,
				cyclic = true,
			}),
			augend.constant.new({
				elements = { "public", "private" },
				word = true,
				cyclic = true,
			}),
		},
	})

	vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = false })
	vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
	vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
	vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
	vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
	vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
	vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
	vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
end

return M
