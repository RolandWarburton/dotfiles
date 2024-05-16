#!/usr/bin/env lua

local lfs = require("lfs")

local home = os.getenv("HOME")
local theme = "dark"

local function toggle_env_var()
  local theme_file = home .. "/.current-theme"

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

toggle_env_var()

-- alacritty
local alacritty_dir = home .. "/.config/alacritty"
local alacritty_theme_source = alacritty_dir .. "/alacritty-" .. theme .. ".yml"
local alacritty_theme_target = alacritty_dir .. "/alacritty.yml"
os.execute("rm " .. alacritty_theme_target)
local success, err = lfs.link(alacritty_theme_source, alacritty_theme_target, true)

-- tmux
local tmux_theme_dir = home .. "/.config/tmux/themes"
local tmux_theme_source = tmux_theme_dir .. "/" .. theme .. ".conf"
local tmux_theme_target = tmux_theme_dir .. "/theme.conf"
os.execute("rm " .. tmux_theme_target)
local success, err = lfs.link(tmux_theme_source, tmux_theme_target, true)
os.execute("tmux source-file " .. home .. "/.tmux.conf")

-- TODO sway
