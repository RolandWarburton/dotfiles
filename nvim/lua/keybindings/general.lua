
-- Modes
--   normal_mode       = "n",
--   insert_mode       = "i",
--   visual_mode       = "v",
--   visual_block_mode = "x",
--   term_mode         = "t",
--   command_mode      = "c",

-- some shortcuts to make the conf file more clean
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local expr = { noremap = true, silent = true, expr = true }

-- map leader key
map("n", ",", "<Nop>", opts)
vim.g.mapleader = ','

-- "ctrl+s % and ctrl+s"
-- use a bang on Vexplore to open to the right
map('n', '<C-s>%', ':Vexplore!<cr>', opts)
map('n', '<C-s>"', ':Hexplore<cr>', opts)

-- turn highlighting off
map('n', '<C-n>', ':noh<cr>', opts)

-- tab navigation
map('n', '<C-PageUp>', ':tabn<cr>', opts)
map('n', '<C-PageDown>', ':tabp<cr>', opts)

-- paste from the system clipboard
-- note system clipboard copy is done in :h clipboard
map('n', 'p', '"+p', opts)


-- fzf.vim keybinds
-- https://github.com/junegunn/fzf.vim/blob/master/README.md

-- open command pallate (leader + p)
map('n', '<Leader>p', ':Command<cr>', opts)

-- open file search (ctrl + p)
map('n', '<C>p', ':Files<cr>', opts)

