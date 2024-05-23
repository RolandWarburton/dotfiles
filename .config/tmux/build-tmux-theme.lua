local theme = require('theme')
local lfs = require('lfs')
local config = require('lua.tmux-theme')

local M = {}

function M.build()
  local home = os.getenv("HOME")
  --   +-----------------------------+
  --   |       tmux-theme.lua        |
  --   |+----------+    +-----------+|
  --   ||dark theme|    |light theme||
  --   |+----------+    +-----------+|
  --   +-----------------------------+
  --                 |
  --                 |
  --                 v
  --        +--------------------+
  --        |build-tmux-theme.lua|
  --        +--------------------+
  --                 |
  --                 |writes the theme file
  --                 v
  --            +----------+
  --            |theme.conf|
  --            +----------+
  --                 ^
  --                 |reads the theme config file
  --               +----+
  --               |tmux|
  --               +----+

  local file_path = home .. "/.config/tmux/themes/theme.conf"
  local file = io.open(file_path, "w")

  if file then
    file:write(config.get_bar_config())
    file:close()
  else
    print("Failed to write to file: " .. file_path)
    os.exit(1)
  end
end

function M.source()
  local home = os.getenv("HOME")
  os.execute("tmux source-file " .. home .. "/.tmux.conf")
end

return M
