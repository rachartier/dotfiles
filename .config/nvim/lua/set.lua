local opt = vim.opt

vim.defer_fn(function()
  opt.spell = false

  vim.opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    cache_enabled = 1,
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end, 50)

opt.autowrite = true
opt.background = "dark"
opt.whichwrap:append("<>[]hl")
opt.iskeyword = "@,48-57,_,192-255,-"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0
opt.ruler = false
opt.foldenable = false
opt.confirm = false
opt.cursorline = true
opt.expandtab = true
opt.formatoptions = "rqnl1j"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.statusline = " "

opt.cmdheight = 0
opt.list = false
opt.pumheight = 20
opt.number = true
opt.relativenumber = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
}
opt.shiftround = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.shortmess:append({
  W = true,
  I = true,
  c = true,
  C = true,
})
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.spelloptions:append("noplainbuffer")
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 4
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 100
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false

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

opt.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,inline:char"

vim.o.timeoutlen = 300

opt.swapfile = false
opt.backup = true
opt.backupdir = os.getenv("HOME") .. "/.local/share/nvim/backup/"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

opt.hlsearch = false

opt.smoothscroll = true
