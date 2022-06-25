-- vocab folder
local home = require'os'.getenv('HOME')
vim.g.user_path_home = home .. '/.config/styles/Vocab'

-- format on save
vim.g.user_format_on_save = false

Toggle_format_on_save = function()
  vim.g.user_format_on_save = not vim.g.user_format_on_save
  -- this schedule fixes printed messages from not appearing
  vim.schedule(
    function()
      print("Format on save is " .. (vim.g.user_format_on_save and 'on.' or 'off.'))
    end
  )
end
