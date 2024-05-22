local theme = require('theme-switcher')

local script_path = arg[0]
local c = theme.get_colors()

local M = {}

local barThemeBase = [[
# DO NOT EDIT THIS FILE
# This file is generated by %s
# Please edit this file instead to change the bar configuration

bar {
  position top
  strip_workspace_numbers yes

  # When the status_command prints a new line to stdout, swaybar updates.
  # The default just shows the current date and time.
  # Find valid flags for the status bar here https://github.com/RolandWarburton/sway-bar-status-line
  status_command $HOME/.config/sway/statusBar

  # bar colors
  %s
}
]]

local barDarkTheme = [[
colors {
    focused_workspace %s %s %s
    background %s
    inactive_workspace %s %s %s
  }
]]

barDarkTheme = string.format(
  barDarkTheme,
  c.base1,
  c.accent1,
  c.accent3,
  c.base1,
  c.base1,
  c.base3,
  c.accent3
)

local barLightTheme = [[
colors {
    focused_workspace %s %s %s
    background %s
    inactive_workspace %s %s %s
  }
]]

barLightTheme = string.format(
  barLightTheme,
  c.base1,   -- active tab border
  c.base1,   -- active tab background
  c.accent2, -- active tab text
  c.base1,   -- bar background
  c.base1,
  c.base1,
  c.base2
)

M.get_bar_config = function()
  local theme_current = theme.get_theme_value()
  if theme_current == "light" then
    return string.format(barThemeBase, script_path, barLightTheme)
  else
    return string.format(barThemeBase, script_path, barDarkTheme)
  end
end

return M
