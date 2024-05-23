local tablex = require('pl.tablex')
-- local lfs = require('lfs')
local theme = require('theme')
local config = require('lua.alacritty-theme')

local home = os.getenv("HOME")
-- local theme_current = theme.get_theme_value()

local M = {}

-- combines the {theme}.yaml file with the alacritty template
-- to create the alacritty.yml file that alacritty can read
M.build = function()
  -- +---------+ +----------+
  -- |dark.yaml| |light.yaml|
  -- +--+------+ +-----+----+
  --    |              |
  --    +----+     +---+
  --         v     v
  --     +-------------+     +----------------------------+
  --     |alacritty.yml|<----|   alacritty.template.yml   |
  --     | (compiled)  |     |(basic theme without colors)|
  --     +------+------+     +----------------------------+
  --            |
  --            |reads compiled yaml
  --            |
  --   +--------+-----------+
  --   |alacritty (terminal)|
  --   +--------------------+
  local alacritty_dir = home .. "/.config/alacritty"
  local alacritty_theme_target = alacritty_dir .. "/alacritty.template.yml"

  -- read and parse alacritty template
  local alacritty_config, err = theme.read_yaml(alacritty_theme_target)
  if not alacritty_config then
    print("Error reading:", err)
    return os.exit(1, true)
  end

  -- read the alacritty theme
  local alacritty_theme = config.get_config()

  -- merge the theme into the config
  local alacritty_merged_config = tablex.merge(alacritty_config, alacritty_theme, true)
  local success, err = theme.write_yaml(alacritty_dir .. "/alacritty.yml", { alacritty_merged_config })
  if not success then
    print("Error writing:", err)
    return os.exit(1, true)
  end
end

return M
