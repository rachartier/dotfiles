local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M._get_filename(fullpath, path_to_remove)
    fullpath = fullpath:gsub("\\", "/")
    path_to_remove = path_to_remove:gsub("\\", "/")

    fullpath = fullpath:gsub("/$", "")
    path_to_remove = path_to_remove:gsub("/$", "")

    local fullpath_len = #fullpath
    local path_to_remove_len = #path_to_remove

    local i = 1
    while i <= fullpath_len and i <= path_to_remove_len do
        if fullpath:sub(i, i) == path_to_remove:sub(i, i) then
            i = i + 1
        else
            break
        end
    end

    if i > path_to_remove_len then
        -- Remove pathToRemove and any leading slash
        return fullpath:sub(i + 1)
    else
        return fullpath
    end
end

M.get_list_buffers = function()
    local buffer_list = ""
    buffer_list = vim.fn.execute("ls t")

    local buf_names = vim.split(buffer_list, "\n")

    table.remove(buf_names, 1)

    if #buf_names >= 2 then
        local temp = buf_names[1]
        buf_names[1] = buf_names[2]
        buf_names[2] = temp
    end

    local cwdpath = vim.fn.getcwd():gsub("%~", vim.fn.expand("$HOME")):gsub("\\", "/")

    local path1 = cwdpath

    local buffer_names = {}
    for _, line in ipairs(buf_names) do
        local name = line:match('"([^"]+)"')
        if name then
            local home = name:gsub("%~", vim.fn.expand("$HOME")):gsub("\\", "/")
            local remainingPath = M._get_filename(home, path1)
            local extension = remainingPath:match("^.+%.(.+)$")
            local icon, color = require("nvim-web-devicons").get_icon(remainingPath, extension)

            table.insert(buffer_names, { icon = icon, color = color, path = remainingPath })
        end
    end

    return buffer_names
end

function M.select_buffers(opts)
    opts = opts or require("telescope.themes").get_dropdown({})

    local displayer = require("telescope.pickers.entry_display").create({
        separator = " ",
        items = {
            { width = 1 },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        return displayer({
            { entry.icon, entry.color },
            entry.path,
        })
    end

    pickers
        .new(opts, {
            prompt_title = "Navigate to a Buffer",
            finder = finders.new_table({
                results = M.get_list_buffers(),
                entry_maker = function(entry)
                    return {
                        value = entry,
                        ordinal = entry.path,
                        color = entry.color,
                        path = entry.path,
                        icon = entry.icon,
                        display = make_display,
                    }
                end,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    local selected = selection.value.path

                    if selected ~= "" and selected ~= nil and selected ~= "[No Name]" then
                        vim.cmd("buffer " .. selected)
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
