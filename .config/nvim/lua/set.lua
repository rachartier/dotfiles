local opt = vim.opt

vim.cmd([[
    let &t_TI = "\<Esc>[>4;2m"
    let &t_TE = "\<Esc>[>4;m"
]])

opt.autowrite = true -- Enable auto write

opt.clipboard = "unnamedplus"

if vim.fn.has("wsl") == 1 then
	vim.api.nvim_create_autocmd("TextYankPost", {

		group = vim.api.nvim_create_augroup("Yank", { clear = true }),

		callback = function()
			vim.fn.system("clip.exe", vim.fn.getreg('"'))
		end,
	})
end

local conf = require("config")
vim.opt.pumblend = conf.pumblend -- Popup blend
vim.opt.winblend = conf.winblend -- Window blend

opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0 -- Hide * markup for bold and italic
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.cmdheight = 1
opt.list = false -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumheight = 20 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.softtabstop = 4
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "fr", "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
end

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.api.nvim_command("filetype plugin on")
--
opt.termguicolors = true
-- opt.nu = true
-- opt.relativenumber = true
--
-- opt.tabstop = 4
-- opt.softtabstop = 4
-- opt.shiftwidth = 4
-- opt.expandtab = true
--
-- opt.smartindent = true
--
-- opt.wrap = false

opt.swapfile = false
opt.backup = true
opt.backupdir = os.getenv("HOME") .. "/.local/share/nvim/backup/"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

-- opt.scrolloff = 8
-- opt.signcolumn = "yes"
-- opt.isfname:append("@-@")
--
-- opt.updatetime = 50
-- opt.fillchars = "eob: "
-- -- opt.pumblend = 20
--
-- opt.laststatus = 0
--
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local U = require("utils")

vim.fn.sign_define("DiagnosticSignError", { text = U.diagnostic_signs.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = U.diagnostic_signs.warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = U.diagnostic_signs.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = U.diagnostic_signs.hint, texthl = "DiagnosticSignHint" })

vim.cmd([[let &t_Cs = "\e[4:3m"]]) -- Undercurl
vim.cmd([[let &t_Ce = "\e[4:0m"]]) -- Undercurl

-- vim.g.markdown_recommended_style = 0
