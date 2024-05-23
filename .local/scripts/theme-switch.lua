#!/usr/bin/env lua

local lfs = require('lfs')
local theme = require('theme')

local home = os.getenv("HOME")
local current_theme = "dark"

theme.toggle_env_var()

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

local function toggle_tmux_theme()
  local module_path = home .. '/.config/tmux/?.lua'
  package.path = package.path .. ';' .. module_path
  require('build-tmux-theme').build()
end

toggle_sway_theme()
os.execute('zsh -i -c "/usr/local/bin/swaymsg reload"')
toggle_alacritty_theme()
toggle_tmux_theme()
