local M = {}

local theme = require('theme')
local c = theme.get_colors()

local darkTheme = [[
color_base03=%s
color_base0=%s
color_base1=%s
color_yellow=%s
color_bright_black=%s

# Set window status colors
setw -g window-status-current-style "fg=$color_yellow bg=$color_base03 bold"

# Status line colors
set -g status-style "fg=terminal,bg=$color_base1"

# Pane colors
set -g pane-border-style "fg=$color_bright_black,bg=$color_base03"
set -g pane-active-border-style "fg=$color_base0,bg=$color_base03"

# Window colors
set-window-option -g window-active-style "bg=terminal"
set-window-option -g window-style "bg=$color_base03"

# Tab colors
set-window-option -g window-status-current-style "bg=$color_base03"
]]

local lightTheme = [[
color_base03=%s
color_base0=%s
color_base1=%s
color_bar_inactive=%s
color_bar_active=%s

# Set window status colors
setw -g window-status-current-style "fg=$color_yellow bg=$color_base03 bold"

# Status line colors
set -g status-style "fg=terminal,bg=$color_base1"

# Pane colors
set -g pane-border-style "fg=$color_bar_inactive,bg=$color_bar_inactive"
set -g pane-active-border-style "fg=$color_bar_active,bg=$color_bar_active"

# Window colors
set-window-option -g window-active-style "bg=terminal"
set-window-option -g window-style "bg=$color_base03"

# Tab colors
set-window-option -g window-status-current-style "bg=$color_base03"
]]

darkTheme = string.format(
  darkTheme,
  c.base1,
  c.base3,
  c.accent1,
  c.accent1,
  c.base3
)

lightTheme = string.format(
  lightTheme,
  c.base2,
  c.base2,
  c.accent1,
  c.base2,
  c.base1
)

M.get_bar_config = function()
  local theme_current = theme.get_theme_value()
  if theme_current == "light" then
    return lightTheme
  else
    return darkTheme
  end
end

return M
