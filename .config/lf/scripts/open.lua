local utils = require("scriptutils")

local function get_script_dir()
  local info = debug.getinfo(1, "S")
  local script_path = info.source:sub(2) -- Remove "@" at the start
  return script_path:match("(.*/)")
end
local script_dir = get_script_dir()

-- Helper to escape shell arguments safely
local function shell_escape(str)
  return "'" .. str:gsub("'", "'\"'\"'") .. "'"
end

-- Get environment variables passed by lf
local fx    = os.getenv("fx") or ""
local f     = os.getenv("f") or ""

-- If marked files exist, split them; else fall back to current file
local files = {}
if fx ~= "" then
  for file in fx:gmatch("[^\n]+") do
    table.insert(files, file)
  end
elseif f ~= "" then
  table.insert(files, f)
end

-- Function to get MIME type of a file
local function get_mime(file)
  local cmd = "file --mime-type -bL " .. shell_escape(file)
  local result, exit_code = utils.exec(cmd)
  if exit_code ~= 0 then os.exit(1) end
  return result and result:gsub("%s+", "") or nil -- trim
end

-- Open files based on MIME type
for _, file in ipairs(files) do
  local mime = get_mime(file)
  if mime and (mime:match("^text/") or mime == "application/json") then
    os.execute(script_dir .. "tmux-open-in-marked-pane " .. shell_escape(file))
  else
    os.execute("xdg-open " .. shell_escape(file))
  end
end
