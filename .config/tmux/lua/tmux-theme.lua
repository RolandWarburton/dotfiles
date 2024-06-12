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
inactive_pane_background=%s
window_bar_background=%s
inactive_pane_border=%s
active_pane_border=%s

# Set window status colors
setw -g window-status-current-style "fg=$window_bar_background bg=$inactive_pane_background bold"
setw -g window-status-style "fg=$inactive_pane_background bg=$window_bar_background bold"

# Status line colors
set -g status-style "fg=terminal,bg=$window_bar_background"

# Pane colors
set -g pane-border-style "fg=$inactive_pane_border,bg=$inactive_pane_border"
set -g pane-active-border-style "fg=$active_pane_border,bg=$active_pane_border"

# Window colors
set-window-option -g window-active-style "bg=terminal"
set-window-option -g window-style "bg=$inactive_pane_background"

# Tab colors
#set-window-option -g window-status-current-style "bg=$inactive_pane_background"

# right status
# required to hard code color255 here because it doesnt like hex color codes
set -g status-right "#[fg=color255,bg=default] #(whoami) "
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
  c.base2, -- inactive pane background
  c.base3, -- window bar background
  c.base2, -- inactive pane border
  c.base1  -- active pane border
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
