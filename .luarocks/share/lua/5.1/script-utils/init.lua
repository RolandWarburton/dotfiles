local M = {}

-- implements table.pack from lua 5.2
local function pack(...)
  return { n = select("#", ...), ... }
end

--- Exit the program if an error occurs.
-- This function checks for an error (non-nil `err`) and prints an error message.
-- If an error is found, it exits the program with status code 1.
-- If no error is found, it returns the value.
--
-- @return any: Returns the value if no error is detected.
-- @example
-- foo = function()
--   return "value", nil
-- end
-- local value = M.exit_if_error(foo())
--
-- If `restic_read_config()` returns a non-nil error, the program will exit, otherwise, it will assign `config`.
M.exit_if_error = function(...)
  local args = pack(...)
  local values = {}
  for i = 1, args.n - 1 do
    table.insert(values, args[i])
  end

  -- the error will be the last argument
  local err = select(-1, ...)
  if err ~= nil then
    print(string.format("ERROR: %s", err))
    os.exit(1)
  end
  return unpack(values)
end

-- executes a command synchronously returning the output and exit code
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

-- returns true if the provided path ends with any of the provided extensions
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

M.two_col = function(s1, s2)
  print(string.format("%-32s %-32s", s1, s2))
end

-- returns the directory name with an appending slash
M.dirname = function(file_path)
  return (file_path:gsub("/*$", "")):match("(.*/)") or "."
end

return M
