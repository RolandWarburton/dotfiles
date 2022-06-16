-- store some useful util helpers
-- local currentFile = vim.cmd("echo expand('%:p')")
local is

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

-- map telescope fzf to appropriate ctrl+p to find files
local isInGit = os.execute('git rev-parse --is-inside-work-tree')
if isInGit == "true"then
  map('n', '<C-p>', ':Telescope git_files<cr>', opts)
else
  map('n', '<C-p>', ':Telescope find_files<cr>', opts) -- careful with this on slow computers
end

-- fuzzy find vim commands
map('n', '<Leader>p', ':Telescope commands<cr>', opts)

-- mimic "Find active file in file explorer" in VSCode
-- vim.cmd('command RevealFile NvimTreeFindFile')
-- vim.cmd[[command! RevealFile v:lua.revealFileFoo()]]

function _G.revealFileFoo()
  local windowNumber = tostring(vim.cmd('echo winnr()'))
  print(windowNumber)
  print(windowNumber)
  if windowNumber == '1' then
    print('hello')
  end

  if tostring(windowNumber) == '1' then
    vim.cmd('NvimTreeFindFile')
    print('showing')
  end

  if windowNumber == '2' then
    print('hiding')
    vim.cmd('call win_gotoid(win_getid(2))')
  end
end


-- map F1 to jump to file tree
map('n', '<F1>', ':lua revealFileFoo()<cr>', opts)
