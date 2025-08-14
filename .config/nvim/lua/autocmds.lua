-- vim.api.nvim_create_autocmd({ "TextYankPost" }, {
-- 	vim.highlight.on_yank({
-- 		higroup = "CurSearch",
-- 		timeout = 85,
-- 		priority = 1,
-- 	})
-- end, {
-- 	target = "*",
-- 	desc = "Highlight yanked text",
-- })

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype

    if not string.find(ft, "Avante") then
      local current_tab = vim.fn.tabpagenr()
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
    end
  end,
  desc = "Resize splits if window got resized",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function(event)
    if event.match:match("^json") then
      vim.opt_local.conceallevel = 0
    end
  end,
  desc = "Disable conceallevel for json files",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
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
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Easy quit buffers",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "Enable wrap and spell for markdown and text files",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Create directory if it does not exist",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  desc = "Remove trailing whitespace",
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd('normal! g`"zz')
      end)
    end
  end,
  desc = "Restore cursor position",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
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

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, false, {})
  end,
})

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function(event)
    if vim.opt.buftype:get() == "terminal" then
      local set = vim.opt_local
      set.number = false -- Don't show numbers
      set.relativenumber = false -- Don't show relativenumbers
      set.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer
      vim.opt.filetype = "terminal"

      vim.cmd.startinsert() -- Start in insert mode
    end
  end,
  desc = "Settings for terminal buffers",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~/.config/kitty/kitty.conf"),
  callback = function()
    vim.fn.system("kill -SIGUSR1 $(pgrep kitty)")
  end,
})
