return {
	"ThePrimeagen/harpoon",
	enabled = false,
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED
		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-e>", function()
			toggle_telescope(harpoon:list())
		end)

		local keys = {
			"&",
			"é",
			'"',
			"'",
			"(",
			"-",
		}
		for i, k in ipairs(keys) do
			vim.keymap.set("n", "<C-" .. k .. ">", function()
				harpoon:list():select(i)
			end)
		end

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<S-Tab>", function()
			harpoon:list():prev()
		end)

		vim.keymap.set("n", "<Tab>", function()
			harpoon:list():next()
		end)
	end,
}
