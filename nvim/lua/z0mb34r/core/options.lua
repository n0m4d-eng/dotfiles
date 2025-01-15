vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indents
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = false -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting a new one.

opt.wrap = false

-- search settings
opt.ignorecase = true -- search is case insensitive
opt.smartcase = true -- if you include mixed case in search, assumes its case sensitive


opt.cursorline = true

-- term gui colors
opt.termguicolors = true
opt.background = "dark" -- light colorschemes will be made dark
opt.signcolumn = "yes" -- show sign column so text doesn't shift

--backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insertmode start pos

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split-windows
opt.splitright = true -- splits vert windws to the right
opt.splitbelow = true -- split horiz windows to the bottom


-- turn off swapfile
opt.swapfile = false

