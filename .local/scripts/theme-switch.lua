#!/usr/bin/env lua

local lfs = require("lfs")
local yaml = require("lyaml")

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

local function removePrefix(str, prefix)
  if str:sub(1, #prefix) == prefix then
    return str:sub(#prefix + 1)
  else
    return str
  end
end

local function removeSuffix(str, suffix)
  if str:sub(- #suffix) == suffix then
    return str:sub(1, -(#suffix + 1))
  else
    return str
  end
end

local function read_yaml(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil, "File not found: " .. file_path
  end
  local content = file:read("*all")
  file:close()
  local yaml_content = yaml.load(content)
  -- print(yaml_content.font.size)
  return yaml_content
end

local function write_yaml(file_path, content)
  local file = io.open(file_path, "w")
  if not file then
    return false, "Failed to open file for writing: " .. file_path
  end
  local str = yaml.dump(content)
  str = removePrefix(str, "---\n")
  str = removeSuffix(str, "...\n")
  file:write(str)
  file:close()
  return true
end

toggle_env_var()

-- alacritty
local alacritty_dir = home .. "/.config/alacritty"
local alacritty_theme_source = alacritty_dir .. "/alacritty-" .. theme .. ".yml"
local alacritty_theme_target = alacritty_dir .. "/alacritty.template.yml"
-- os.execute("rm " .. alacritty_theme_target)
-- local success, err = lfs.link(alacritty_theme_source, alacritty_theme_target, true)

-- read and parse alacritty_theme_target
local parsed_yaml, err = read_yaml(alacritty_theme_source)
if not parsed_yaml then
  print("Error reading:", err)
  return os.exit(1, true)
end
parsed_yaml.colors = parsed_yaml.colors or {}
parsed_yaml.colors.primary = parsed_yaml.colors.primary or {}
parsed_yaml.colors.primary.background = '#383C4A'
parsed_yaml.colors.primary.foreground = '#ffffff'
local success, err = write_yaml(alacritty_dir .. "/alacritty.yml", { parsed_yaml })
if not success then
  print("Error writing:", err)
  return os.exit(1, true)
end

-- -- tmux
-- local tmux_theme_dir = home .. "/.config/tmux/themes"
-- local tmux_theme_source = tmux_theme_dir .. "/" .. theme .. ".conf"
-- local tmux_theme_target = tmux_theme_dir .. "/theme.conf"
-- os.execute("rm " .. tmux_theme_target)
-- local success, err = lfs.link(tmux_theme_source, tmux_theme_target, true)
-- os.execute("tmux source-file " .. home .. "/.tmux.conf")

-- TODO sway
