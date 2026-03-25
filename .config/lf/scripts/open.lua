local function shell_escape(str)
  return "'" .. str:gsub("'", "'\"'\"'") .. "'"
end

local function get_mime(file)
  local handle = io.popen("file --mime-type -bL " .. shell_escape(file))
  if not handle then os.exit(1) end
  local result = handle:read("*l")
  handle:close()
  return result
end

local image_files = {}
local other_files = {}
for file in (os.getenv("fx") or ""):gmatch("[^\n]+") do
  local mime = get_mime(file)
  if mime and mime:match("^image/") then
    table.insert(image_files, shell_escape(file))
  else
    table.insert(other_files, shell_escape(file))
  end
end

-- specially handle images to batch
-- them in one imv-wayland command
if #image_files > 0 then
  os.execute("imv-wayland " .. table.concat(image_files, " ") .. " &")
end

-- open all other file types
for _, file in ipairs(other_files) do
  os.execute("xdg-open " .. file)
end
