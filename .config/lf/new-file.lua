#!/usr/bin/lua

local lfs = require("lfs")

local function exists(path)
  local attr = lfs.attributes(path)
  return attr ~= nil
end

io.write("Please enter a file name: ")
local filename = io.read()

-- check we are not overwriting anything
if exists(filename) then
  print("Refusing to overwrite " .. filename:match("([^/]+)$"))
  return 0
end

print(filename)

-- remove first / to avoid absolute paths
if filename:sub(1, 1) == '/' then
  filename = filename:sub(2)
end

-- check if the last char is a /
-- this determines if we are creating a file or a folder
local last_character = filename:sub(-1)
if last_character == '/' then
  os.execute("mkdir -p " .. filename)
else
  local count = 0
  for _ in filename:gmatch("[^/]+") do count = count + 1 end
  if count > 2 then
    -- get the path to the last segment
    -- Example: foo/bar/baz/bee -> foo/bar/baz
    local dir = filename:match("(.*/)[^/]*$"):gsub("/$", "")
    os.execute('mkdir -p ' .. dir)
  end
  os.execute('touch "' .. filename .. '"')
end

os.execute('lf -remote "send reload"')
