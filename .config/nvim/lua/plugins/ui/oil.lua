local git_ignored = setmetatable({}, {
	__index = function(self, key)
		local proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
			cwd = key,
			text = true,
		})
		local result = proc:wait()
		local ret = {}
		if result.code == 0 then
			for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
				-- Remove trailing slash
				line = line:gsub("/$", "")
				table.insert(ret, line)
			end
		end

		rawset(self, key, ret)
		return ret
	end,
})

return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>te",
			function()
				require("oil").open_float()
			end,
			desc = "Open Oil",
		},
	},
	config = function()
		require("oil").setup({

			delete_to_trash = true,
			keymaps = {
				["<BS>"] = "actions.parent",
				["<ESC>"] = "actions.close",
				["q"] = "actions.close",
			},
			win_options = {
				signcolumn = "yes:1",
			},
			float = {
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
				override = function(conf)
					local win_height = math.ceil(vim.o.lines * 0.3)
					local win_width = math.ceil(vim.o.columns * 0.4)

					local row = math.ceil((vim.o.lines - win_height) * 0.4)
					local col = math.ceil((vim.o.columns - win_width) * 0.5)

					conf.width = win_width
					conf.height = win_height
					conf.row = row
					conf.col = col

					return conf
				end,
			},
			preview = {

				border = require("config.icons").default_border,
				-- Whether the preview window is automatically updated when the cursor is moved
				update_on_cursor_moved = true,
			},
			view_options = {
				is_hidden_file = function(name, _)
					-- dotfiles are always considered hidden
					if vim.startswith(name, ".") then
						return true
					end
					local dir = require("oil").get_current_dir()
					-- if no local directory (e.g. for ssh connections), always show
					if not dir then
						return false
					end
					-- Check if file is gitignored
					return vim.list_contains(git_ignored[dir], name)
				end,
			},
		})

		require("utils").on_event("FileType", function()
			vim.opt_local.relativenumber = false
			vim.opt_local.number = false
			vim.opt_local.numberwidth = 5
		end, {
			target = "oil",
		})
	end,
}
