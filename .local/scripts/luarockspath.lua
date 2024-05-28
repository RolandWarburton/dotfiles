#!/usr/bin/lua

local function trim(s)
  return s:match "^%s*(.-)%s*$"
end

local function isEmptyOrWhitespace(s)
  return s:match("^%s*$") ~= nil
end

local function splitKeyValue(str)
  local key, value = str:match("([^=]+)=(.+)")
  return key, value
end

local Parser = {}

function Parser.parsePath(path, pattern)
  local parts = {}
  for part in string.gmatch(path .. pattern, "(.-)" .. pattern) do
    if not isEmptyOrWhitespace(trim(part)) then
      table.insert(parts, trim(part))
    end
  end
  return parts
end

function Parser.printParts(t)
  for _, v in ipairs(t) do
    print(v)
  end
end

local pathString = io.read("*all")
print(pathString)
if pathString == "" or not pathString then
  os.exit(1, true)
end

pathString = pathString:gsub("\n", "")
local parts = Parser.parsePath(pathString, "export")

for _, part in ipairs(parts) do
  local key, value = splitKeyValue(part)
  if not key or not value then return end
  print("\n" .. key)
  if key == "LUA_PATH" or key == "LUA_CPATH" then
    local values = Parser.parsePath(value, ";")
    Parser.printParts(values)
  else
    local values = Parser.parsePath(value, ":")
    Parser.printParts(values)
  end
end
