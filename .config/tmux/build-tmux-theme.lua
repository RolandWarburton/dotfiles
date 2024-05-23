local theme = require('theme')
local lfs = require('lfs')

local M = {}

function M.build()
  local home = os.getenv("HOME")
  local theme_current = theme.get_theme_value()
  -- +----------+    +-----------+
  -- |dark theme|    |light theme|
  -- +----------+    +-----------+
  --     |                |
  --     |                |
  --     |symlink         |symlink
  --     |                |
  --     |  +----------+  |
  --     +->|theme.conf|<-+
  --        +----------+
  --             ^
  --             |reads the symlinked theme
  --           +----+
  --           |tmux|
  --           +----+
  local tmux_theme_dir = home .. "/.config/tmux/themes"
  local tmux_theme_source = tmux_theme_dir .. "/" .. theme_current .. ".conf"
  local tmux_theme_target = tmux_theme_dir .. "/theme.conf"

  -- remove the old theme symlink
  os.execute("rm " .. tmux_theme_target)

  -- link the theme source to the theme target
  local success, err = lfs.link(tmux_theme_source, tmux_theme_target, true)
  return success
end

function M.source()
  local home = os.getenv("HOME")
  os.execute("tmux source-file " .. home .. "/.tmux.conf")
end

return M
