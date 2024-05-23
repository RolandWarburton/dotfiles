local M = {}

local theme = require('theme')
local c = theme.get_colors()

local darkTheme = {
  colors = {
    primary = {
      background = '#383C4A',
      foreground = '#ffffff'
      -- background = c.base1,
      -- foreground = '#ffffff'
    },
  },
}

local lightTheme = {
  colors = {
    primary = {
      -- background = '#F6F5F4',
      background = c.base1,
      foreground = '#000000'
    },
  },
}

M.get_config = function()
  local theme_current = theme.get_theme_value()
  if theme_current == "light" then
    return lightTheme
  else
    return darkTheme
  end
end

return M
