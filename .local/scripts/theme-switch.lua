#!/usr/bin/env lua

local lfs = require('lfs')
local theme = require('theme')

local home = os.getenv("HOME")
local current_theme = "dark"

theme.toggle_env_var()

local function toggle_tmux_theme()
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
  local tmux_theme_source = tmux_theme_dir .. "/" .. current_theme .. ".conf"
  local tmux_theme_target = tmux_theme_dir .. "/theme.conf"

  -- remove the old theme symlink
  os.execute("rm " .. tmux_theme_target)

  -- link the theme source to the theme target
  local success, err = lfs.link(tmux_theme_source, tmux_theme_target, true)
  if success then
    os.execute("tmux source-file " .. home .. "/.tmux.conf")
  end
end

local function toggle_sway_theme()
  local module_path = home .. '/.config/sway/?.lua'
  package.path = package.path .. ';' .. module_path
  require('build-sway-theme')
end

local function toggle_alacritty_theme()
  local module_path = home .. '/.config/alacritty/?.lua'
  package.path = package.path .. ';' .. module_path
  require('build-alacritty-config').build()
end

toggle_env_var()
toggle_alacritty_theme()
toggle_tmux_theme()
toggle_sway_theme()
os.execute('zsh -i -c "/usr/local/bin/swaymsg reload"')
