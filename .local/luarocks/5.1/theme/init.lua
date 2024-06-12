local lfs = require("lfs")
local yaml = require("lyaml")

local M = {}

-- returns the current value of ~/.theme-current
function M.get_theme_value()
  local home = os.getenv("HOME")
  local theme_file = home .. "/.theme-current"
  local file = io.open(theme_file, "r")
  local theme = "dark"
  if file then
    theme = file:read("*line")
    file:close()
  end
  return theme
end

function M.get_script_current_directory()
  -- Get the full path of the current script
  local info = debug.getinfo(1, "S")
  local script_path = info.source:match("^@(.+)$")

  -- Extract the directory path from the full path
  if script_path then
    return script_path:match("^(.*[\\/])")
  else
    return nil, "Unable to determine script directory"
  end
end

M.colors = {
  light = {
    base1 = "#CCC6C2",
    base2 = "#B4B0AD",
    base3 = "#969696",
    accent1 = "#285577",
    accent2 = "#000000",
    accent3 = "#ffffff"
  },
  dark = {
    base1 = "#2f333e",
    base2 = "#383C4A",
    base3 = "#F6F5F4",
    accent1 = "#285577",
    accent2 = "#000000",
    accent3 = "#ffffff"
  }
}

function M.get_colors()
  local theme = "dark"
  theme = M.get_theme_value()
  if theme == "light" then
    return M.colors.light
  else
    return M.colors.dark
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

-- toggles the theme variable stored in the theme file
function M.toggle_env_var()
  local home = os.getenv("HOME")
  local theme_file = home .. "/.theme-current"
  local theme = "dark"

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

return M
