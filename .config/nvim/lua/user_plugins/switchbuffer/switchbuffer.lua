local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

M.setup = function(options)
    M.opts = options

    -- vim.api.nvim_set_hl(0, "SwitchBufferModified", options.hl_modified or { link = "NeoTreeModified" })
    -- vim.api.nvim_set_hl(0, "SwitchBufferNormal", options.hl_normal or { link = "Normal" })
end

function M._get_filename_relative_path(fullpath, path_to_remove)
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

function M.get_symbol(filename)
    local devicons = pcall(require, "nvim-web-devicons")
    if not devicons then
        return "", nil
    end

    local ext = string.match(filename, "%.([^%.]*)$")

    if ext then
        ext = ext:gsub("%s+", "")
    end

    local symbol, hl = require("nvim-web-devicons").get_icon(filename, ext, { default = false })

    if symbol == nil then
        if filename:match("^term://") then
            symbol = " "
        else
            symbol = " "
        end
    end

    return symbol, hl
end

function M.format_filename(filename, filename_max_length)
    local function trunc_filename(fn, fn_max)
        if string.len(fn) <= fn_max then
            return fn
        end

        local substr_length = fn_max - string.len("...")
        if substr_length <= 0 then
            return string.rep(".", fn_max)
        end

        return "..." .. string.sub(fn, -substr_length)
    end

    filename = string.gsub(filename, "term://", "Terminal: ", 1)
    filename = trunc_filename(filename, filename_max_length)

    return filename
    -- return filename
end

-- function M._get_filename(fullpath)
--     return fullpath:match("([a-zA-Z0-9_.-]+)$")
-- end

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

    local buffer_names = {}
    for _, line in ipairs(buf_names) do
        local name = line:match('"([^"]+)"')
        local id = tonumber(line:match("([0-9]+) "))
        if name then
            local buf_modified = vim.api.nvim_buf_get_option(id, "modified")

            local path = name
            local formated_filename = M.format_filename(path, 45)
            local icon, icon_color = M.get_symbol(path)
            local path_color = "Normal"
            local status_color = "Normal"
            local status = ""

            if buf_modified then
                -- path_color = "NeoTreeModified"
                status = require("utils").signs.file.not_saved
                status_color = "SwitchBufferStatusColor"
            end

            if vim.fn.getbufvar(id, "bufpersist") ~= 1 then
                path_color = "Comment"
            end

            table.insert(buffer_names, {
                icon = icon,
                formated_path = formated_filename,
                path = path,
                icon_color = icon_color,
                path_color = path_color,
                status = status,
                status_color = status_color,
            })
        end
    end

    return buffer_names
end

function M.select_buffers(opts)
    opts = opts or require("telescope.themes").get_dropdown({})

    local displayer = require("telescope.pickers.entry_display").create({
        separator = " ",
        items = {
            { width = 2 },
            { width = 2 },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        return displayer({
            { entry.icon,          entry.icon_color },
            { entry.status,        entry.status_color },
            { entry.formated_path, entry.path_color },
        })
    end

    local function create_finders_table()
        return finders.new_table({
            results = M.get_list_buffers(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    ordinal = entry.path,
                    path_color = entry.path_color,
                    icon_color = entry.icon_color,
                    formated_path = entry.formated_path,
                    path = entry.path,
                    icon = entry.icon,
                    status = entry.status,
                    status_color = entry.status_color,
                    display = make_display,
                }
            end,
        })
    end

    pickers
        .new(opts, {
            prompt_title = "Navigate to a Buffer",
            finder = create_finders_table(),
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
                map("i", "<C-d>", function()
                    local selection = action_state.get_selected_entry()
                    local selected = selection.value.path

                    if selected ~= "" and selected ~= nil and selected ~= "[No Name]" then
                        vim.cmd("bdelete " .. selected)

                        local current_picker = action_state.get_current_picker(prompt_bufnr)
                        current_picker:refresh(create_finders_table(), {})
                    end
                end)

                return true
            end,
        })
        :find()
end

return M
