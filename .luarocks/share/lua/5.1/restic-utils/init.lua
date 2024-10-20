local util = require("script-utils")
local lyaml = require("lyaml")

local M = {}

local get_pass_secret = function(credential_path)
  -- Run the `pass` command and capture the output
  local result, exit_code = util.exec("pass " .. credential_path)
  if exit_code ~= 0 then
    return nil, "[FAIL] failed to get aws secrets from password store"
  end

  -- Parse the YAML output using lyaml
  local parsed_yaml = lyaml.load(result)

  if type(parsed_yaml) == "table" then
    return parsed_yaml, nil
  elseif not parsed_yaml then
    return nil, "[FAIL] failed to parse secret (nil result)"
  else
    return nil, "[FAIL] failed parse aws secret"
  end
end

-- returns the repository password and aws keys
M.get_repository_secrets = function()
  local err                   = nil
  local secrets               = nil
  local repository_secret     = nil
  local aws_access_key        = nil
  local aws_secret_access_key = nil

  local hostname              = util.exec("/bin/hostname")
  if hostname == "" or hostname == nil then
    print("failed to get hostname")
    os.exit(1, true)
  end
  -- get repository secrets
  secrets, err = get_pass_secret("restic/secrets")
  if err ~= nil or secrets == nil then
    return nil, err
  end

  repository_secret     = secrets.hosts[hostname].password and secrets.hosts[hostname].password or nil
  aws_access_key        = secrets.aws.access_key and secrets.aws.access_key or nil
  aws_secret_access_key = secrets.aws.secret_access_key and secrets.aws.secret_access_key or nil

  if not (repository_secret or aws_access_key or aws_secret_access_key) then
    err = "failed to read an secret value"
  end

  return aws_access_key, aws_secret_access_key, repository_secret, err
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
M.restic_get_repository_path = function(config)
  local bucket_name = nil
  local err = nil

  if config.aws_s3_url == nil then
    err = "aws_s3_url not defined in config file"
    return nil, err
  end

  if config.bucket_name then
    bucket_name = config.bucket_name
  else
    local hostname = util.exec("/bin/hostname")
    if hostname == "" or hostname == nil then
      err = "failed to get hostname"
    end
    bucket_name = "restic-archive-" .. hostname
  end

  if err ~= nil then
    return nil, err
  else
    return config.aws_s3_url .. bucket_name, nil
  end
end

return M
