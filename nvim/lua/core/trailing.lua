-- SHOW TRAILING WHITESPACE

-- old method (show a char in the trailing space instead)
-- vim.cmd('set listchars-=trail:1')

-- new method (use a highlight group
vim.highlight.create("TrailingSpaces", { ctermbg = "red", guibg = "red" })

-- now apply the highlight group match
-- the use of [[]] quotes is to allow for this regex to be used in a string
-- http://lua-users.org/wiki/StringsTutorial
vim.cmd([[match TrailingSpaces /\s\+$/]])

-- this shows an empty space and is required when `list` and `listchars` are being used
vim.cmd([[set listchars+=trail:\ ]])

