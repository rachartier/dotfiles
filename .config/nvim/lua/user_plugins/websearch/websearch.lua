local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local uname = vim.loop.os_uname()

M.OS = uname.sysname
M.IS_MAC = M.OS == 'Darwin'
M.IS_LINUX = M.OS == 'Linux'
M.IS_WINDOWS = M.OS:find 'Windows' and true or false
M.IS_WSL = M.IS_LINUX and uname.release:find 'Microsoft' and true or false

M.search_engines = {
    ["google"]        =  "https://www.google.com/search?q=",
    ["bing"]          =  "https://www.bing.com/search?q=",
    ["brave"]         =  "https://search.brave.com/search?q=",
    ["yahoo"]         =  "https://search.yahoo.com/search?p=",
    ["duckduckgo"]    =  "https://www.duckduckgo.com/?q=",
    ["startpage"]     =  "https://www.startpage.com/do/search?q=",
    ["yandex"]        =  "https://yandex.ru/yandsearch?text=",
    ["github"]        =  "https://github.com/search?q=",
    ["baidu"]         =  "https://www.baidu.com/s?wd=",
    ["ecosia"]        =  "https://www.ecosia.org/search?q=",
    ["goodreads"]     =  "https://www.goodreads.com/search?q=",
    ["qwant"]         =  "https://www.qwant.com/?q=",
    ["stackoverflow"] =  "https://stackoverflow.com/search?q=",
    ["wolframalpha"]  =  "https://www.wolframalpha.com/input/?i=",
    ["archive"]       =  "https://web.archive.org/web/*/",
    ["scholar"]       =  "https://scholar.google.com/scholar?q=",
    ["ask"]           =  "https://www.ask.com/web?q="
}

M.default_engine = "google"

function M.urlencode(str)
    str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
    function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
    return str
end

function M.capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function M.websearch(engine, query)
    local url = M.search_engines[engine] .. M.urlencode(query)

    -- only for WSL2
    os.execute("cmd.exe /c start " .. url .. " >/dev/null 2>&1 &")
end

function M.websearch_input(engine)
    if engine == nil then
        engine = M.default_engine
    end

    local query = vim.fn.input("Query " .. M.capitalize(engine) .. " > ")

    if query == nil or query == '' then
        return
    end

    local url = M.search_engines[engine] .. M.urlencode(query)
    local command = nil

    if M.IS_MAC then
        command = "open "
    elseif M.IS_LINUX then
        command = "nohup xdg-open "
    elseif M.IS_WSL or M.IS_WINDOWS then
        command = "cmd.exe /c start "
    end

    os.execute(command .. url .. " >/dev/null 2>&1 &")
end

function M.get_keys_search_engine()
    local keyset = {}
    local n=0

    for k, _ in pairs(M.search_engines) do
        n=n+1
        keyset[n]=k
    end

    return keyset
end

function M.select_engine(opts)
    opts = opts or require("telescope.themes").get_dropdown{}

    pickers.new(opts, {
        prompt_title = "Search engine",
        finder = finders.new_table {
            results = M.get_keys_search_engine()
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                M.websearch_input(selection[1])
            end)
            return true
        end,
    }):find()
end


vim.api.nvim_create_user_command("WebSearch",
function(opts)
    M.websearch(opts.fargs[1], opts.fargs[2])
end,
{ nargs = "*" }
)

vim.api.nvim_create_user_command("WebSearchInput",
function(opts)
    if opts.fargs[1] == nil then
        M.select_engine()
    else
        M.websearch_input(opts.fargs[1])
    end
end,
{ nargs = "*" }
)


return M

