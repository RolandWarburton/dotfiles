local M = {}

M.exec = function(command)
  local handle = nil

  command = command .. " ; echo $?"
  handle = io.popen(command, "r")
  if handle == nil then os.exit(1, true) end
  local result = handle:read("*a"):match("^%s*(.-)%s*$")
  handle:close()

  -- get the exit code
  local exit_code = tonumber(result:match("(%d+)$"))
  -- remove the exit code from the result
  result = result:gsub("(%d+)$", ""):match("^%s*(.-)%s*$")

  return result, exit_code
end

-- returns T/F if a pid contains child processes
M.pidHasChildren = function(pid)
  local rc = os.execute("ps --ppid " .. pid .. " --no-header > /dev/null")
  if rc == 0 then
    return true
  else
    return false
  end
end

-- returns a table of PIDs for a given parent PID (ppid)
M.get_children = function(ppid)
  local cmd = "ps --ppid " .. ppid .. " -o pid="
  local result = M.exec(cmd)
  local children = {}

  for pid in string.gmatch(result, "%d+") do
    table.insert(children, pid)
    local child_children = M.get_children(pid)
    for _, child_pid in ipairs(child_children) do
      table.insert(children, child_pid:match("^%s*(.-)%s*$"))
    end
  end

  return children
end

-- returns true i the provided path is an image
M.path_has_extension = function(file_path, test_extensions)
  -- Extract the extension from the file path (only considering the last period)
  local extension = file_path:match("^.+(%.[^%.]+)$")

  -- Check if the extension is in the list of image extensions
  if extension then
    for _, ext in ipairs(test_extensions) do
      if extension:lower() == ext then
        return true
      end
    end
  end

  return false
end

function dirname(file_path)
    return (file_path:gsub("/*$", "")):match("(.*/)") or "."
end

return M
