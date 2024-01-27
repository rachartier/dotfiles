local M = {
	"rachartier/mind.nvim",
}

function M.config()
	require("mind").setup({
		ui = {
			width = 35,
		},
	})

	local group_name = "MindResizeGroup"
	local mind_augroup = vim.api.nvim_create_augroup(group_name, { clear = true })

	function ToggleMindWindow()
		local mind_win_found = false
		local windows = vim.api.nvim_list_wins()

		for _, winid in ipairs(windows) do
			local bufid = vim.api.nvim_win_get_buf(winid)
			if vim.api.nvim_buf_get_option(bufid, "filetype") == "mind" then
				mind_win_found = true
				if vim.o.columns < 120 then
					vim.api.nvim_win_close(winid, true)
					require("mind").close()
				end
				break
			end
		end

		if not mind_win_found and vim.o.columns > 120 then
			if require("utils").directory_exists_in_root(".mind") then
				vim.cmd("MindOpenProject")
			else
				vim.cmd("MindOpenMain")
			end

			vim.cmd(":wincmd l")
		end
	end

	vim.api.nvim_create_autocmd({ "VimResized" }, {
		group = mind_augroup,
		callback = ToggleMindWindow,
	})

	vim.api.nvim_create_augroup("AutocloseMindBuffer", { clear = true })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = "AutocloseMindBuffer",
		callback = function()
			local num_visible_windows = 0
			for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.api.nvim_win_get_config(win).relative == "" then
					num_visible_windows = num_visible_windows + 1
				end
			end

			if num_visible_windows < 2 then
				if vim.bo.filetype == "mind" then
					vim.cmd("q!")
				end
			end
		end,
	})
end

return M
