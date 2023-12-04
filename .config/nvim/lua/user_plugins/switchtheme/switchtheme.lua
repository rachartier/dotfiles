local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local U = require("utils")
M.setup = function(options)
	M.opts = options
	M.default_theme = options.default
	M.actual = require("themes." .. M.default_theme .. ".theme")
end

function M.get_actual()
	return M.actual
end

function M.get_colors()
	return M.actual.get_colors()
end

function M.get_lualine_colors()
	return M.actual.get_lualine_colors()
end

function M.get_themes_list()
	local themes = {}
	for _, theme in ipairs(M.opts.themes) do
		table.insert(themes, {
			name = theme,
		})
	end
	return themes
end

function M.select_themes(opts)
	opts = opts or require("telescope.themes").get_dropdown({})

	local displayer = require("telescope.pickers.entry_display").create({
		separator = " ",
		items = {
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			{ entry.name },
		})
	end

	local function create_finders_table()
		return finders.new_table({
			results = M.get_themes_list(),
			entry_maker = function(entry)
				return {
					value = entry,
					ordinal = entry.name,
					name = entry.name,
					display = make_display,
				}
			end,
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Switch theme",
			finder = create_finders_table(),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local selected = selection.value.name

					if selected ~= "" and selected ~= nil and selected ~= "[No Name]" then
						print(selected)

						M.actual = require("themes." .. selected .. ".theme")
					end
				end)

				map("i", "<Tab>", actions.move_selection_next)
				map("i", "<S-Tab>", actions.move_selection_previous)
				map("i", "<Esc>", actions.close)

				return true
			end,
		})
		:find()
end

return M
