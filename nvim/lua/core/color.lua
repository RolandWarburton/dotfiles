-- use for EOL and SPACE
vim.cmd('hi Nontext ctermfg=\'Gray\'')

-- use for the column ruler
vim.cmd('hi ColorColumn ctermbg=\'Gray\'')

-- use for EOL, space
vim.highlight.create("SpecialKey", { ctermbg = "Gray", ctermfg = 07 })

vim.opt.termguicolors = true

