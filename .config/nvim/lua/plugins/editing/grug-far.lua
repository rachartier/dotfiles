return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		{
			"<leader>rw",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
		},
		{
			"<leader>R",
			function()
				require("grug-far").open({ transient = true })
			end,
		},
	},
	config = function()
		local utils = require("utils")

		utils.on_event({ "FileType" }, function()
			vim.schedule(function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.cursorline = false
			end)
		end, {
			target = {
				"grug-far",
			},
			desc = "GrugFar settings",
		})
	end,
}
