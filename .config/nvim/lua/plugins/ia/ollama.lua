local M = {
	"nvim-lua/popup.nvim",
}
local function run(model, context, prompt, buf_nr, win)
    if prompt == nil then
        vim.api.nvim_win_close(win, true)
        return
    end
	-- prepare the command string
	local cmd = ("ollama run $model $prompt")
		:gsub("$model", model)
		:gsub("$prompt", vim.fn.shellescape(context .. "\n" .. prompt))

	-- print the prompt header
	local header = vim.split(prompt, "\n")
	table.insert(header, "----------------------------------------")
	vim.api.nvim_buf_set_lines(buf_nr, 0, -1, false, header)

	local line = vim.tbl_count(header) + 1
	local words = {}

	-- start the async job
	return vim.fn.jobstart(cmd, {
		on_stdout = function(_, data, _)
			for i, token in ipairs(data) do
				if i > 1 then -- if returned data array has more than one element, a line break occured.
					line = line + 1
					words = {}
				end
				table.insert(words, token)
				vim.api.nvim_buf_set_lines(buf_nr, line, line + 1, false, { table.concat(words, "") })
			end
		end,
	})
end

function M.config()
	vim.keymap.set("n", "<leader>cc", function()
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "Output will be generated here..." })

        local gheight = vim.api.nvim_list_uis()[1].height
local gwidth = vim.api.nvim_list_uis()[1].width
local width = 30
local height = 30

		local opts = {
                relative = "editor",
        width = width,
        height = height,
        row = (gheight - height) * 0.5,
        col= (gwidth - width) * 0.5,
			title = "Codellama",
			border = "rounded",
		}
		local win = vim.api.nvim_open_win(buf, false, opts)

		local variant = "instruct"

		if vim.bo.filetype == "python" then
			variant = "python"
		end

		run(
			"codellama:" .. variant,
			"'You are an expert programmer that writes simple, concise code and explanations. ",
			vim.fn.input("Prompt: "),
			buf,
            win
		)
	end, { silent = true })
end

return M
