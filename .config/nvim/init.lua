vim.loader.enable()

vim.g.mapleader = " "

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

require("set")
require("remap")
require("autocmds")

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.keymap.set("n", "<Leader>db", function()
    local curbufnr = vim.api.nvim_get_current_buf()
    local buflist = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buflist) do
        if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
            vim.cmd("bd " .. tostring(bufnr))
        end
    end
end, { silent = true, desc = "Close unused buffers" })

require("theme")
