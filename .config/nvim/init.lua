vim.loader.enable()

vim.g.mapleader = " "

vim.cmd([[
    augroup _astro
        autocmd!
        autocmd BufRead,BufEnter *.p8 set filetype=pico8
    augroup end
]])

local U = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
    ui = {
        border = U.default_border,
    },
})

require("remap")
require("set")

local augroup = vim.api.nvim_create_augroup
local Group = augroup("Group", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = Group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local id = vim.api.nvim_create_augroup("startup", {
    clear = false,
})

local persistbuffer = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = id,
    pattern = { "*" },
    callback = function()
        vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
            buffer = 0,
            once = true,
            callback = function()
                persistbuffer()
            end,
        })
    end,
})

vim.keymap.set("n", "<Leader>db", function()
    local curbufnr = vim.api.nvim_get_current_buf()
    local buflist = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buflist) do
        if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
            vim.cmd("bd " .. tostring(bufnr))
        end
    end
end, { silent = true, desc = "Close unused buffers" })

-- https://gist.github.com/linguini1/ee91b6d8c196cbd731d10a61447af6a3
vim.api.nvim_create_augroup("py-fstring", { clear = true })
vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = { "*.py" },
    group = "py-fstring",
    --- @param opts AutoCmdCallbackOpts
    --- @return nil
    callback = function(opts)
        -- Only run if f-string escape character is typed
        if vim.v.char ~= "{" then
            return
        end

        -- Get node and return early if not in a string
        local node = vim.treesitter.get_node()

        if not node then
            return
        end
        if node:type() ~= "string" then
            node = node:parent()
        end
        if not node or node:type() ~= "string" then
            return
        end

        vim.print(node:type())
        local row, col, _, _ = vim.treesitter.get_node_range(node)

        -- Return early if string is already a format string
        local first_char = vim.api.nvim_buf_get_text(opts.buf, row, col, row, col + 1, {})[1]
        vim.print("row " .. row .. " col " .. col)
        vim.print("char: '" .. first_char .. "'")
        if first_char == "f" then
            return
        end

        -- Otherwise, make the string a format string
        vim.api.nvim_input("<Esc>m'" .. row + 1 .. "gg" .. col + 1 .. "|if<Esc>`'la")
    end,
})

require("theme")
