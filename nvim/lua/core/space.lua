-- SHOW SPACES

-- method one
-- vim.highlight.create("Spaces", { ctermbg = "red", guibg = "red" })
-- vim.cmd([[match TrailingSpaces /\s/]])

-- method two

-- this is the same as `set list`
vim.opt.list = true
vim.cmd('set listchars+=space:·')

-- this fixes trailing spaces from being
vim.cmd([[set listchars+=trail:\ ]])

