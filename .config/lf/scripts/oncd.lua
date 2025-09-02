#!/usr/bin/env lua
local cwd = os.getenv("PWD")

local client_id = arg[1]
if not client_id or client_id == "" then
  print("no ID!")
  os.exit(0)
end

-- Function to run lf -remote command
local function send(cmd)
  os.execute(string.format("lf -remote 'send %s %s'", client_id, cmd))
end

-- Decide what to do based on PWD
if cwd == "/home/" .. os.getenv("USER") or cwd == "/" then
  send("set ratios 1")
else
  -- Check if we're in a Git root (.git dir exists)
  local f = io.open(".git", "r")
  if f then
    f:close()
    send("set ratios 1")
  else
    send("set ratios 1:2")
  end
end
