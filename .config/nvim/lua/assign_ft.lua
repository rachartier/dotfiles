local utils = require("utils")

local function assign_ft(target, ft)
	utils.on_event({ "BufReadPost" }, function()
		vim.opt_local.filetype = ft
	end, {
		target = target,
		desc = "Set filetype " .. target .. " to " .. ft,
	})
end

assign_ft("*.p8", "pico8")
assign_ft("*.dotfile*", "bash")
assign_ft("*.tcss", "css")
