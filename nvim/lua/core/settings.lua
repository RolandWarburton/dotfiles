-- GENERAL SETTINGS

-- soft tab 2 spaces
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- relative number lines
vim.opt.relativenumber = true

-- shows better messages
vim.opt.cmdheight = 1

-- ruler
vim.opt.colorcolumn = '100'

-- timeout length
vim.opt.timeoutlen = 300

-- Fix comments (see :h fo-table and :h formatoptions)
-- -= is subtracting the following values
-- c -> auto-wrap comments using textwidth
-- r -> auto insert comment after pressing <Enter> in insert mode
-- o -> auto insert comment after pressing "o" or "O" in normal mode
vim.cmd('autocmd BufEnter * set formatoptions-=cro')

-- create splits in these directions
vim.opt.splitright = true
vim.opt.splitbelow = true

-- use the clipboard for ALL operations (instead of having to use + register)
vim.opt.clipboard = 'unnamedplus'

-- disable word wrap
vim.opt.wrap = false

-- when scrolling, do it 8 chars at a time (default is 1)
vim.opt.sidescroll = 8

-- offset the side scrolling to start scrolling at an effective 8+8 chars
vim.opt.sidescrolloff = 8

-- set the font for gui
vim.opt.guifont = "Hack:h10"

-- wait this long for a command to finish
vim.opt.timeoutlen = 1000

-- the width of the gutter numbers
vim.opt.numberwidth = 4

-- highlight the current line
vim.opt.cursorline = true
vim.highlight.create("CursorLine", {cterm='NONE', ctermbg='8', ctermfg='15'})   -- text row
vim.highlight.create("CursorLineNR", {cterm='NONE', ctermbg='8', ctermfg='15'}) -- the number row

-- disable the close (X) button on vim tab line
vim.cmd('set guioptions-=e')

