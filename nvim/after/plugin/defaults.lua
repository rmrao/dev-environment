local api = vim.api
local g = vim.g
local opt = vim.opt

-- Remap leader and local leader to <Space>
api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

opt.termguicolors = true -- Enable colors in terminal
opt.hlsearch = true --Set highlight on search
opt.number = true --Make line numbers default
opt.relativenumber = true --Make relative number default
opt.mouse = "a" --Enable mouse mode
opt.breakindent = true --Enable break indent
opt.undofile = true --Save undo history
opt.ignorecase = true --Case insensitive searching unless /C or capital in search
opt.smartcase = true -- Smart case
opt.updatetime = 250 --Decrease update time
opt.signcolumn = "yes" -- Always show sign column
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.timeoutlen = 500 -- Time in milliseconds to wait for a mapped sequence to complete.

opt.joinspaces = false -- No double spaces with join after a dot
opt.sessionoptions = "buffers,curdir,help,tabpages,winsize,winpos,terminal"
opt.smartindent = true --Smart indent
opt.expandtab = true
opt.smarttab = true
opt.textwidth = 0
opt.autoindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 3 -- Global statusline
opt.cmdheight = 1 -- 0
opt.scrollback = 100000
opt.splitkeep = "screen"
opt.hidden = true

-- Better Netrw
g.netrw_banner = 0 -- Hide banner
g.netrw_browse_split = 4 -- Open in previous window
g.netrw_altv = 1 -- Open with right splitting
g.netrw_liststyle = 3 -- Tree-style view
g.netrw_fastbrowse = 0  -- close after opening a file
g.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore

-- Folding
-- Treesitter based folding
opt.foldlevel = 3
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- opt.foldcolumn = "1"
-- opt.foldlevel = 99
-- opt.foldlevelstart = -1
-- opt.foldenable = true

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Don't continue comments
vim.cmd("autocmd FileType * set formatoptions-=cro")

