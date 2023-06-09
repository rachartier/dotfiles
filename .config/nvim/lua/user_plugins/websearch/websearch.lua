local M = {}

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
    local query = vim.fn.input("Query " .. M.capitalize(M.default_engine) .. " > ")

    if query == nil or query == '' then
        return
    end

    local url = M.search_engines[engine] .. M.urlencode(query)

    os.execute("cmd.exe /c start " .. url .. " >/dev/null 2>&1 &")
end


vim.api.nvim_create_user_command("WebSearch",
function(opts)
    M.websearch(opts.fargs[1], opts.fargs[2])
end,
{ nargs = "*" }
)

vim.api.nvim_create_user_command("WebSearchInput",
function(opts)
    M.websearch_input(M.default_engine)
end,
{}
)

return M

