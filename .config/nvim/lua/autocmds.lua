local utils = require("utils")

-- utils.on_event({ "TextYankPost" }, function()
-- 	vim.highlight.on_yank({
-- 		higroup = "CurSearch",
-- 		timeout = 85,
-- 		priority = 1,
-- 	})
-- end, {
-- 	target = "*",
-- 	desc = "Highlight yanked text",
-- })

utils.on_event({ "VimResized" }, function()
  local ft = vim.bo.filetype

  if not string.find(ft, "Avante") then
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end
end, {
  target = "*",
  desc = "Resize splits if window got resized",
})

utils.on_event({ "FileType" }, function(event)
  if event.match:match("^json") then
    vim.opt_local.conceallevel = 0
  end
end, {
  target = { "json", "jsonc", "json5" },
  desc = "Disable conceallevel for json files",
})

utils.on_event("FileType", function(event)
  vim.bo[event.buf].buflisted = false
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
end, {
  target = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "Avante",
    "AvanteInput",
    "oil",
    "copilot-panel",
  },
  desc = "Easy quit buffers",
})

utils.on_event({ "FileType" }, function()
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end, {
  target = { "gitcommit", "markdown", "text" },
  desc = "Enable wrap and spell for markdown and text files",
})

utils.on_event({ "BufWritePre" }, function(event)
  if event.match:match("^%w%w+://") then
    return
  end
  local file = vim.loop.fs_realpath(event.match) or event.match
  vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
end, {
  target = "*",
  desc = "Create directory if it does not exist",
})

utils.on_event({ "BufWritePre" }, function()
  vim.cmd([[%s/\s\+$//e]])
end, {
  target = "*",
  desc = "Remove trailing whitespace",
})

utils.on_event({ "BufReadPost" }, function(args)
  local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
  local line_count = vim.api.nvim_buf_line_count(args.buf)
  if mark[1] > 0 and mark[1] <= line_count then
    vim.api.nvim_buf_call(args.buf, function()
      vim.cmd('normal! g`"zz')
    end)
  end
end, {
  target = "*",
  desc = "Restore cursor position",
})

utils.on_event("FileType", function()
  vim.opt_local.buflisted = false
end, {
  target = "qf",
  desc = "Do not list quickfix buffers",
})

-- Corrige le problème d'indentation en python lorsque
-- l'on sort du mode insertion si on a mit plusieurs tabulations
-- utils.on_event("InsertLeave", function()
-- 	vim.cmd("normal! ==")
-- end, {
-- 	target = "*.py",
-- 	desc = "Auto format line in python file",
-- })

-- autocmd("User", {
-- 	pattern = "CustomFormatCopilot",
-- 	callback = function(args)
-- 		local str_lines_count = tostring(args.data.lines_count)
--
-- 		vim.cmd("normal! " .. str_lines_count .. "k")
-- 		vim.cmd("normal! " .. str_lines_count .. "==")
-- 	end,
-- 	group = augroup("custom_copilot"),
-- })
-- utils.on_event("FileType", function(event)
-- 	vim.cmd("topleft Outline")
-- end, {
-- 	target = { "markdown" },
-- 	desc = "Outline for markdown",
-- })

utils.on_event({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, function()
  if vim.fn.mode() ~= "c" then
    vim.cmd("checktime")
  end
end)

-- Notification after file change
utils.on_event("FileChangedShellPost", function()
  vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, false, {})
end)

-- Set local settings for terminal buffers
utils.on_event("TermOpen", function(event)
  if vim.opt.buftype:get() == "terminal" then
    local set = vim.opt_local
    set.number = false -- Don't show numbers
    set.relativenumber = false -- Don't show relativenumbers
    set.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer
    vim.opt.filetype = "terminal"

    vim.cmd.startinsert() -- Start in insert mode
  end
end, {
  target = "term://*",
  desc = "Settings for terminal buffers",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~/.config/kitty/kitty.conf"),
  callback = function()
    vim.fn.system("kill -SIGUSR1 $(pgrep kitty)")
  end,
})
