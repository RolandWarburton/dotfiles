local util = require("script-utils")
local lyaml = require("lyaml")

local M = {}

M.extract_aws_secrets = function()
  -- Run the `pass` command and capture the output
  local result, exit_code = util.exec("pass restic/aws")
  if exit_code ~= 0 then
    return nil, "[FAIL] failed to get aws secrets from password store"
  end

  -- Parse the YAML output using lyaml
  local parsed_yaml = lyaml.load(result)

  if parsed_yaml then
    local aws_secrets = {
      access_key = parsed_yaml.secrets.access_key,
      secret_access_key = parsed_yaml.secrets.secret_access_key
    }
    return aws_secrets, nil
  else
    return nil, "[FAIL] failed parse aws secrets"
  end
end

M.extract_repository_secret = function()
  local host = util.exec("/bin/hostname")
  local secret, exit_code = util.exec("pass restic/" .. host)
  if exit_code ~= 0 then
    return nil, "failed to get repository secret"
  else
    return secret, nil
  end
end

M.restic_folder_exists = function(restic_backup_dir_path)
  local exit_code, folder_exists = nil, nil
  exit_code = os.execute("[ -d " .. restic_backup_dir_path .. " ]")
  if exit_code == 0 then folder_exists = true end

  if folder_exists then
    return "restic directory already exists"
  else
    return nil
  end
end

M.restic_folder_is_empty = function(restic_backup_dir_path)
  local d = restic_backup_dir_path
  local exit_code, folder_is_empty = nil, nil
  exit_code = os.execute("find " .. d .. " -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null | grep -q .")
  if exit_code == 0 then folder_is_empty = false end

  if folder_is_empty == false then
    return "restic directory already has contents"
  else
    return nil
  end
end

M.restic_config_exists = function(restic_config_dir)
  local restic_config_stat = util.exec("stat " .. restic_config_dir)

  if restic_config_stat == "" then
    return "[FAIL] restic config does not exist"
  else
    util.two_col("[OK] restic config exists", restic_config_dir)
    return nil
  end
end

---@class ResticConfig
---@field restic_backup_dir string
---@field restic_config_dir string
---@field aws_s3_url string

--- Reads the Restic configuration file.
--- @return ResticConfig|nil config The loaded configuration, or nil if an error occurs.
--- @return string|nil err An error message, or nil if no error occurred.
M.restic_read_config = function()
  local home = os.getenv("HOME")
  if home == "" or home == nil then
    return nil, "failed to get home from environment"
  end
  local filepath = home .. "/.config/restic/config.yaml"
  local file = io.open(filepath)
  if file == nil then return nil, "failed to read config file" end
  local file_contents = file:read("*a")

  local config = lyaml.load(file_contents)

  if config then
    return config, nil
  else
    return nil, "failed to parse config"
  end
end

return M
