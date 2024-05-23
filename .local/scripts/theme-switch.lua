#!/usr/bin/env lua

local theme = require('theme')
local home = os.getenv("HOME")
theme.toggle_env_var()

local function toggle_sway_theme()
  local module_path = home .. '/.config/sway/?.lua'
  package.path = package.path .. ';' .. module_path
  local sway = require('build-sway-theme')
  sway.build()
  sway.source()
end

local function toggle_alacritty_theme()
  local module_path = home .. '/.config/alacritty/?.lua'
  package.path = package.path .. ';' .. module_path
  local alacritty = require('build-alacritty-config')
  alacritty.build()
end

local function toggle_tmux_theme()
  local module_path = home .. '/.config/tmux/?.lua'
  package.path = package.path .. ';' .. module_path
  local tmux = require('build-tmux-theme')
  tmux.build()
  tmux.source()
end

toggle_sway_theme()
toggle_alacritty_theme()
toggle_tmux_theme()
