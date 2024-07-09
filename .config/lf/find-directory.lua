#!/bin/lua
-- ################################################################################
-- # Integrates fdfind with lf to allow searching for files and directories
-- ################################################################################

local hidden_flag = 0

for _, arg in ipairs(arg) do
  if arg == "--hidden" then
    hidden_flag = 1
    break
  end
end

local excludeTable = { ".git", "git", ".cargo", "node_modules" }
local exclude = table.concat(excludeTable, " --exclude ")
local command
if hidden_flag == 1 then
  command = "lf -remote \"send $id cd '$(fdfind --type d --exclude " .. exclude .. " --hidden | fzf)'\""
else
  command = "lf -remote \"send $id cd '$(fdfind --type d --exclude " .. exclude .. " | fzf)'\""
end

os.execute(command)
