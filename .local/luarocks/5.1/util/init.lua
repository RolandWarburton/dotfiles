local lfs = require("lfs")
local yaml = require("lyaml")

local M = {}

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

function M.read_yaml(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil, "File not found: " .. file_path
  end
  local content = file:read("*all")
  file:close()
  local yaml_content = yaml.load(content)
  return yaml_content, nil
end

function M.write_yaml(file_path, content)
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

return M
