local opt = vim.opt

opt.autowrite = true -- Enable auto write

vim.schedule(function()
	-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

	if vim.fn.has("wsl") == 1 then
		-- if vim.fn.executable("wl-copy") == 0 then
		--     print("wl-clipboard not found, clipboard integration won't work")
		-- else
		--     vim.g.clipboard = {
		--         name = "wl-clipboard (wsl)",
		--         copy = {
		--             ["+"] = 'wl-copy --foreground --type text/plain',
		--             ["*"] = 'wl-copy --foreground --primary --type text/plain',
		--         },
		--         paste = {
		--             ["+"] = (function()
		--                 return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', {''}, 1) -- '1' keeps empty lines
		--             end),
		--             ["*"] = (function()
		--                 return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', {''}, 1)
		--             end),
		--         },
		--         cache_enabled = true
		--     }
		-- end
		vim.g.clipboard = {
			name = "WslClipboard",
			copy = {
				["+"] = "clip.exe",
				["*"] = "clip.exe",
			},
			paste = {
				["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			},
			cache_enabled = 0,
		}
		-- if os.getenv("TMUX") then
		-- 	utils.on_event({ "TextYankPost" }, function()
		-- 		vim.fn.system("clip.exe", vim.fn.getreg('"'))
		-- 	end, { target = "*", desc = "Copy yanked text to clipboard" })
		-- end
		-- vim.g.clipboard = {
		-- 	name = "win32yank-wsl",
		-- 	copy = {
		-- 		["+"] = "win32yank.exe -i --crlf",
		-- 		["*"] = "win32yank.exe -i --crlf",
		-- 	},
		-- 	paste = {
		-- 		["+"] = "win32yank.exe -o --lf",
		-- 		["*"] = "win32yank.exe -o --lf",
		-- 	},
		-- 	cache_enabled = 0,
		-- }
	end
end)

local conf = require("config")
opt.pumblend = conf.pumblend -- Popup blend
opt.winblend = conf.winblend -- Window blend

opt.whichwrap:append("<>[]hl")
opt.completeopt = "menu,menuone,noselect" -- Configure completion behavior
opt.conceallevel = 0 -- Hide * markup for bold and italic
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- Formatting options
opt.grepformat = "%f:%l:%c:%m" -- Grep output format
opt.grepprg = "rg --vimgrep" -- Program to use for grep
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- Preview incremental replacement
opt.laststatus = 0 -- Configure status line display
opt.cmdheight = 1 -- Command line height
opt.list = false -- Show some invisible characters (tabs...)
opt.mouse = "a" -- Enable mouse mode
opt.pumheight = 20 -- Maximum number of entries in a popup
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { -- Session options
	"buffers",
	"curdir",
	"tabpages",
	"winsize",
	"help",
	"globals",
	"skiprtp",
}
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.softtabstop = 4 -- Number of tabs for an indent
opt.shortmess:append({ -- Short messages
	W = true,
	I = true,
	c = true,
	C = true,
})
opt.showmode = false -- Don't show mode since we have a status line
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the sign column, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Automatically insert indents
opt.spelllang = { -- Languages for spell checking
	"fr",
	"en",
}
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen" -- Keep screen on split
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.undofile = true -- Enable undo file
opt.undolevels = 10000 -- Undo levels
opt.updatetime = 100 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

opt.fillchars = {
	-- stl = "─",
	-- stlnc = "─",
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

opt.statusline = ""
opt.smoothscroll = true

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.api.nvim_command("filetype plugin on")

opt.termguicolors = true

opt.swapfile = true
opt.autoread = true
opt.backup = true
opt.backupdir = os.getenv("HOME") .. "/.local/share/nvim/backup/"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25

vim.api.nvim_set_var("t_Cs", "\\e[4:3m")
vim.api.nvim_set_var("t_Ce", "\\e[4:0m")
