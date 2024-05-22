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

return M
