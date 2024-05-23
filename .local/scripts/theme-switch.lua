#!/usr/bin/env lua

local tablex = require('pl.tablex')
local lfs = require('lfs')
local util = require('util')

local home = os.getenv("HOME")
local theme = "dark"

-- toggles the theme variable stored in the theme file
local function toggle_env_var()
  local theme_file = home .. "/.theme-current"

  -- Read the current theme from the file, or set a default value
  local file = io.open(theme_file, "r")
  if file then
    theme = file:read("*line")
    file:close()
  end

  -- Toggle the theme
  if theme == "dark" then
    theme = "light"
  else
    theme = "dark"
  end

  -- Save the new theme to the file
  file = io.open(theme_file, "w")
  if file then
    file:write(theme)
    file:close()
  else
    print("Error: Unable to open file " .. theme_file .. " for writing.")
  end
end

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
  local tmux_theme_source = tmux_theme_dir .. "/" .. theme .. ".conf"
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

-- TODO sway
