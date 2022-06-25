-- vocab folder
local home = require'os'.getenv('HOME')
vim.g.user_path_home = home .. '/.config/styles/Vocab'

-- format on save
vim.g.user_format_on_save = false

Toggle_format_on_save = function()
  vim.g.user_format_on_save = not vim.g.user_format_on_save
  -- this schedule fixes printed messages from not appearing
  vim.schedule(
    function()
      print("Format on save is " .. (vim.g.user_format_on_save and 'on.' or 'off.'))
    end
  )
end

-- returns the visual selection as a string
-- https://neovim.discourse.group/t/function-that-return-visually-selected-text/1601/3
function Get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end
