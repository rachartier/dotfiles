return {
	"monaqa/dial.nvim",
    -- stylua: ignore
	keys = {
		{ mode = "n", "<C-a>", function() require("dial.map").inc_normal() end, desc = "Increment Normal" },
		{ mode = "n", "<C-x>", function() require("dial.map").dec_normal() end, desc = "Decrement Normal" },
		{ mode = "n", "g<C-a>", function() require("dial.map").inc_gnormal() end, desc = "Increment GNormal" },
		{ mode = "n", "g<C-x>", function() require("dial.map").dec_gnormal() end, desc = "Decrement GNormal" },
		{ mode = "v", "<C-a>", function() require("dial.map").inc_visual() end, desc = "Increment Visual" },
		{ mode = "v", "<C-x>", function() require("dial.map").dec_visual() end, desc = "Decrement Visual" },
		{ mode = "v", "g<C-a>", function() require("dial.map").inc_gvisual() end, desc = "Increment GVisual" },
		{ mode = "v", "g<C-x>", function() require("dial.map").dec_gvisual() end, desc = "Decrement GVisual" },
	},
	config = function()
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
	end,
}
