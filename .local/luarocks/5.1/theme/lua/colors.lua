local theme = require('theme.lua.theme')
local M = {}

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
  local themeColor = "dark"
  themeColor = theme.get_theme_value()
  if themeColor == "light" then
    return M.colors.light
  else
    return M.colors.dark
  end
end

return M
