local M = {}

M.linter_config_folder = os.getenv("HOME") .. ".config/linter-configs"

function M.length(table)
    local count = 0
    for _, _ in ipairs(table) do
        count = count + 1
    end
    return count
end

M.border_chars_round = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
M.border_chars_none = { "", "", "", "", "", "", "", "" }
M.border_chars_empty = { " ", " ", " ", " ", " ", " ", " ", " " }
M.border_chars_inner_thick = { " ", "▄", " ", "▌", " ", "▀", " ", "▐" }
M.border_chars_outer_thick = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" }
M.border_chars_cmp_items = { "▛", "▀", "▀", " ", "▄", "▄", "▙", "▌" }
M.border_chars_cmp_doc = { "▀", "▀", "▀", " ", "▄", "▄", "▄", "▏" }
M.border_chars_outer_thin = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
M.border_chars_inner_thin = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" }
M.border_chars_outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" }
M.border_chars_outer_thick_telescope = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" }

M.default_border = M.border_chars_round

--M.top_right_corner_thin = "🭾"
--M.top_left_corner_thin = "🭽"

M.git_signs = {
    added = " ",
    modified = " ",
    removed = " ",
    -- added = " ",
    -- modified = " ",
    -- removed = " ",
}

M.signs = {
    file = {
        modified = "󱞁 ",
        not_saved = "󰉉 ",
    },
}

-- M.diagnostic_signs = {
--     error = " ",
--     warning = " ",
--     info = " ",
--     hint = "󱤅 ",
--     other = "󰠠 ",
-- }

M.diagnostic_signs = {
    error = "●",
    warning = "●",
    info = "●",
    hint = "●",
    other = "●",
}

-- M.diagnostic_signs = {
--     error = " ",
--     warning = " ",
--     info = " ",
--     hint = "󱤅 ",
--     other = "󰠠 ",
-- }

M.diagnostic_signs.warn = M.diagnostic_signs.warning

M.kind_icons = {
    Text = " ",
    Method = " ",
    Function = "󰊕 ",
    Constructor = " ",
    Field = " ",
    Variable = " ",
    Class = "󰠱 ",
    Interface = " ",
    Module = "󰏓 ",
    Property = " ",
    Unit = " ",
    Value = " ",
    Enum = " ",
    EnumMember = " ",
    Keyword = "󰌋 ",
    Snippet = "󰲋 ",
    Color = " ",
    File = " ",
    Reference = " ",
    Folder = " ",
    Constant = "󰏿 ",
    Struct = "󰠱 ",
    Event = " ",
    Operator = " ",
    TypeParameter = "󰘦 ",
    Unknown = "  ",
}

function M.buffers_clean()
    local curbufnr = vim.api.nvim_get_current_buf()
    local buflist = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buflist) do
        if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
            vim.cmd("bd " .. tostring(bufnr))
        end
    end
end

function M.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

function M.add_missing(dst, src)
    for k, v in pairs(src) do
        if dst[k] == nil then
            dst[k] = v
        end
    end
    return dst
end

---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param myLinters object[]
---@param myFormatters object[]
---@param myDebuggers string[]
---@param ignoreTools string[]
---@return string[] tools
---@nodiscard
--- from: https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L27-L82
function M.tools_to_autoinstall(myLinters, myFormatters, myDebuggers, ignoreTools)
    -- get all linters, formatters, & debuggers and merge them into one list
    local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
    local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
    local tools = vim.list_extend(linterList, formatterList)
    vim.list_extend(tools, myDebuggers)

    -- only unique tools
    table.sort(tools)
    tools = vim.fn.uniq(tools)

    -- remove exceptions not to install
    tools = vim.tbl_filter(function(tool)
        return not vim.tbl_contains(ignoreTools, tool)
    end, tools)
    return tools
end

return M
