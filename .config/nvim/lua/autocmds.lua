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
  desc = "resize splits if window got resized",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function(event)
    if event.match:match("^json") then
      vim.opt_local.conceallevel = 0
    end
  end,
  desc = "disable conceallevel for json files",
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
    "nvim-undotree",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<cr>",
      { buffer = event.buf, silent = true, desc = "close buffer" }
    )
  end,
  desc = "easy quit buffers",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "enable wrap and spell for text files",
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
  desc = "create directory if it does not exist",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  desc = "remove trailing whitespace",
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
  desc = "restore cursor position",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
  desc = "do not list quickfix buffers",
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
    vim.cmd("checktime")
  end,
  desc = "check if buffer changed outside of vim",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, false, {})
  end,
  desc = "notify when file changed on disk",
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
  desc = "settings for terminal buffers",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~/.config/kitty/kitty.conf"),
  callback = function()
    vim.fn.system("kill -SIGUSR1 $(pgrep kitty)")
  end,
  desc = "reload kitty config on save",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitrebase",
  callback = function()
    local function map_change(lhs, word)
      vim.keymap.set("n", lhs, function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd.normal({ args = { "ciw" .. word }, bang = true })
        vim.api.nvim_win_set_cursor(0, pos)
      end, { buffer = true, desc = "change to " .. word })
    end

    map_change("p", "pick")
    map_change("s", "squash")
    map_change("e", "edit")
    map_change("r", "reword")
    map_change("f", "fixup")
    map_change("d", "drop")

    vim.keymap.set("n", "J", ":m .+1<CR>==", { buffer = true, desc = "move line down" })
    vim.keymap.set("n", "K", ":m .-2<CR>==", { buffer = true, desc = "move line up" })
  end,
  desc = "gitrebase keymaps",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    if path == "" then
      return
    end

    local size = vim.fn.getfsize(path)
    if size <= 0 then
      return
    end

    local threshold = 1.5 * 1024 * 1024 -- 1.5MB
    local max_line_length = 1000

    local is_big = size > threshold
    if not is_big then
      local lines = vim.api.nvim_buf_line_count(ev.buf)
      is_big = (size - lines) / lines > max_line_length
    end

    if not is_big then
      return
    end

    local ft = vim.filetype.match({ buf = ev.buf }) or ""

    vim.bo[ev.buf].swapfile = false
    vim.bo[ev.buf].undolevels = -1

    if vim.fn.exists(":NoMatchParen") ~= 0 then
      vim.cmd.NoMatchParen()
    end

    vim.api.nvim_buf_call(ev.buf, function()
      vim.wo[0].foldmethod = "manual"
      vim.wo[0].statuscolumn = ""
      vim.wo[0].conceallevel = 0
    end)

    vim.b[ev.buf].completion = false
    vim.b[ev.buf].minianimate_disable = true
    vim.b[ev.buf].minihipatterns_disable = true

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.bo[ev.buf].syntax = ft
      end
    end)

    vim.notify(
      ("Big file detected: %s\nSome features have been disabled."):format(
        vim.fn.fnamemodify(path, ":p:~:.")
      ),
      vim.log.levels.WARN
    )
  end,
  desc = "optimize performance for big files",
})
