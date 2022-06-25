-- store some useful util helpers
-- local currentFile = vim.cmd("echo expand('%:p')")

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
  map('n', '<C-p>', ':Telescope find_files hidden=true <cr>', opts) -- careful with this on slow computers
end

-- fuzzy find vim commands
map('n', '<Leader>p', ':Telescope commands<cr>', opts)

-- mimic "Find active file in file explorer" in VSCode
function _G.revealFileJump()
  -- if currently on the nvim tree window
  if string.find(vim.api.nvim_buf_get_name(0), 'NvimTree')  then
    -- move cursor back to the previous window
    local key = vim.api.nvim_replace_termcodes("<C-w>p", true, false, true)
    vim.api.nvim_feedkeys(key, 'n', false)
  else
    -- show or move the cursor to the file in the file tree
    -- check if a file is open (will be an empty string if no file is open)
    if vim.fn.expand('%') == '' then
      vim.cmd('NvimTreeOpen')
    else
      vim.cmd('NvimTreeFindFile')
      -- set a custom name for the tree window
      vim.api.nvim_set_option_value('statusline', 'NvimTree', {scope = 'local'})
    end
  end
end

-- map F1 to jump to file tree
map('n', '<F1>', ':lua revealFileJump()<cr>', opts)

-- tab navigation
map('n', '<Leader>t', ':tabnew<cr>', opts)
map('n', '<Leader>1', '1gt', opts)
map('n', '<Leader>2', '2gt', opts)
map('n', '<Leader>3', '3gt', opts)
map('n', '<Leader>4', '4gt', opts)
map('n', '<Leader>5', '5gt', opts)
map('n', '<Leader>6', '6gt', opts)
map('n', '<Leader>7', '7gt', opts)
map('n', '<Leader>8', '8gt', opts)
map('n', '<Leader>9', '9gt', opts)

-- open command history
-- requires neoclip, and telescope
map('n', '<Leader>c', ':Telescope neoclip<cr>', opts)

-- open last telescope command, preserving state
map('n', '<Leader>r', ':Telescope resume<cr>', opts)

-- live grep
map('n', '<Leader>g', ':Telescope live_grep<cr>', opts)

-- open git with just ":Git" command
vim.api.nvim_create_user_command('Git', ':lua vim.api.nvim_command("Neogit")', {})

-- create a custom command to "format the file"
-- vim.api.nvim_create_user_command('FormatFile', ':lua vim.lsp.buf.formatting()<cr>', {})
vim.api.nvim_create_user_command('FormatFile', ':lua Lsp_formatting()<cr>', {})

-- create a customn command to open nvim tree to vale vocal directory
vim.api.nvim_create_user_command('EditDict', ':NvimTreeOpen /home/roland/.config<cr>', {})

-- create a custom command to toggle format on save
vim.api.nvim_create_user_command('ToggleFormatOnSave', ':lua Toggle_format_on_save()<cr>', {})

-- create a custom command to rename symbols
vim.api.nvim_create_user_command('RenameSymbol', ':lua vim.lsp.buf.rename()<cr>', {})
