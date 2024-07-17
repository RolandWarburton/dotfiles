#!/usr/bin/lua

-- TMUX OPEN IN MARKED PANE
-- Opens a given file path in the first argument in a marked TMUX pane.
--
-- If there is a neovim instance running in the marked pane it will be opened in a split
-- If the pane has a child process(s) already it will refuse to open it.
-- Otherwise the file will be opened normally in a new neovim instance.
-- Files opened with this last method will respect git repository roots and CD to that directory
--
-- Created and intended for use with the LF file manager

local utils = require("script-utils")

local function parseRow(line)
  local paneIndex,
  panePid,
  paneAtLeft,
  paneCurrentCommand,
  paneCurrentPath = line:match("(%d+)%s+(%d+)%s+(%d+)%s+(%S+)%s+(.+)")
  if not paneIndex or paneIndex == "" or
      not panePid or panePid == "" or
      not paneAtLeft or paneAtLeft == "" or
      not paneCurrentCommand or paneCurrentCommand == "" or
      not paneCurrentPath or paneCurrentPath == "" then
    return nil
  end

  local row = {
    paneIndex = paneIndex,
    panePid = panePid,
    paneAtLeft = paneAtLeft,
    paneCurrentCommand = paneCurrentCommand,
    paneCurrentPath = paneCurrentPath
  }
  return row
end

local function getMarkedPane()
  local paneID = utils.exec('tmux list-panes -F "#{?pane_marked,#{pane_pid},}"')
  if string.match(paneID, "^%d+$") then
    return string.match(paneID, "^%d+$")
  else
    return nil
  end
end

local panePID = getMarkedPane()
if not panePID then
  print('no marked pane')
  os.exit(0, true);
end

-- get information about the pane
local fmt = [[
tmux list-panes -F \
"#{pane_index} #{pane_pid} #{pane_at_left} \
#{pane_current_command} #{pane_current_path}" | grep %s
  ]]
local cmd = string.format(fmt, panePID)
local paneInfoString = utils.exec(cmd)
local pane = parseRow(paneInfoString)
if not pane then os.exit(1, true) end

-- flag to check if the pane contains nvim
local paneContainsNvim = false
local paneContainsRunningProcess = false

-- check the panes children
if utils.pidHasChildren(panePID) then
  paneContainsRunningProcess = true
  local children = utils.get_children(panePID)
  -- for each child check if any of its processes are nvim
  for _, child in pairs(children) do
    local ps = utils.exec("ps --no-headers -o comm= " .. child)
    if string.match(ps, "nvim") then
      paneContainsNvim = true
      break
    end
  end
end

local fx = arg[1]             -- the path provided in the argument
local paneID = pane.paneIndex -- the ID of the marked pane

-- if no file path was provided then fail
if fx == nil then
  print('path argument not provided')
  os.exit(1, true)
end

-- if a neovim pane is marked then open it in a vertical split
if paneContainsNvim then
  print("opening in nvim instance " .. paneID)
  local cmd = [[tmux send-keys -t %s ":vsp %s" Enter]]
  os.execute(string.format(cmd, paneID, fx))
  os.execute("tmux select-pane -t " .. paneID)
  os.exit(0, true)
end

-- if the pane contains a running process then refuse to open here
if paneContainsRunningProcess then
  print("refusing to open in pane that has a running process")
  os.exit(0, true)
end

-- open the file in a new instance of neovim
local git_root = utils.exec('git -C "$(dirname \'' .. fx .. '\')" rev-parse --show-toplevel'):gsub("%s+", "")
if git_root then
  -- Inside a git repository, change the root directory and open the file in nvim
  os.execute('tmux send-keys -t ' .. paneID .. ' "cd ' .. git_root .. '" C-m')
  os.execute('tmux send-keys -t ' .. paneID .. ' "nvim ' .. fx .. '" C-m')
  os.execute('tmux select-pane -t ' .. paneID)
else
  -- Not within a git repository, just open the file in nvim
  os.execute('tmux send-keys -t ' .. paneID .. ' "nvim ' .. fx .. '" C-m')
  os.execute('tmux select-pane -t ' .. paneID)
end
