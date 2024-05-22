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
    base1 = "#F6F5F4",
    base2 = "#929286",
    base3 = "#5c5c5c",
    accent1 = "#285577",
    accent2 = "#000000",
    accent3 = "#ffffff"
  },
  dark = {
    base1 = "#323232",
    base2 = "#F6F5F4",
    base3 = "#5c5c5c",
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

return M
