local util = require("script-utils")
local lyaml = require("lyaml")

local M = {}

M.extract_aws_secrets = function()
  -- Run the `pass` command and capture the output
  local result, exit_code = util.exec("pass restic/minio")
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
    if aws_secrets.access_key == "null" or
        aws_secrets.access_key == nil or
        aws_secrets.access_key == "" or
        aws_secrets.secret_access_key == "null" or
        aws_secrets.secret_access_key == nil or
        aws_secrets.secret_access_key == "" then
      return nil, "aws secrets were not defined correctly"
    else
      return aws_secrets, nil
    end
  else
    return nil, "[FAIL] failed parse aws secrets"
  end
end

M.extract_repository_secret = function()
  local host = util.exec("/bin/hostname")
  local secret, exit_code = util.exec("pass restic/" .. host)
  if exit_code ~= 0 or secret == "" or secret == nil then
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
---@field restic_secrets_path string
---@field restic_backup_shell_script_path string
---@field restic_backup_targets string
---@field restic_exclude_file string
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

-- Returns the full S3 repository name including the bucket name
M.restic_get_repository_name = function()
  local hostname = util.exec("/bin/hostname")
  if hostname == "" or hostname == nil then
    print("failed to get hostname")
    os.exit(1, true)
  end

  local config, err = M.restic_read_config()
  if err ~= nil or config == nil then
    print(err)
    return os.exit(1)
  end
  if config.aws_s3_url == nil then return nil, "aws_s3_url not defined in config file" end

  local aws_s3_url = config.aws_s3_url .. "restic-archive-" .. hostname
  return aws_s3_url, nil
end

return M
