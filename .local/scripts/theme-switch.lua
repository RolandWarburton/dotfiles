#!/usr/bin/env lua

local tablex = require('pl.tablex')
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

local function toggle_alacritty_theme()
  local alacritty_dir = home .. "/.config/alacritty"
  local alacritty_theme_source = alacritty_dir .. "/alacritty-" .. theme .. ".yml"
  local alacritty_theme_target = alacritty_dir .. "/alacritty.template.yml"

  -- read and parse alacritty template
  local alacritty_config, err = util.read_yaml(alacritty_theme_target)
  if not alacritty_config then
    print("Error reading:", err)
    return os.exit(1, true)
  end
  -- read and parse the alacritty theme
  local alacritty_theme, err = util.read_yaml(alacritty_theme_source)
  if not alacritty_theme then
    print("Error reading:", err)
    return os.exit(1, true)
  end
  -- merge the theme into the config
  local alacritty_merged_config = tablex.merge(alacritty_config, alacritty_theme, true)
  local success, err = util.write_yaml(alacritty_dir .. "/alacritty.yml", { alacritty_merged_config })
  if not success then
    print("Error writing:", err)
    return os.exit(1, true)
  end
end

toggle_env_var()
toggle_alacritty_theme()



-- -- tmux
-- local tmux_theme_dir = home .. "/.config/tmux/themes"
-- local tmux_theme_source = tmux_theme_dir .. "/" .. theme .. ".conf"
-- local tmux_theme_target = tmux_theme_dir .. "/theme.conf"
-- os.execute("rm " .. tmux_theme_target)
-- local success, err = lfs.link(tmux_theme_source, tmux_theme_target, true)
-- os.execute("tmux source-file " .. home .. "/.tmux.conf")

-- TODO sway
