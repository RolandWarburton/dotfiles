#!/usr/bin/lua
local util               = require("script-utils")
local restic             = require("restic-utils")

local config             = nil
config                   = util.exit_if_error(restic.restic_read_config())

-- get repository information
local exclude_file       = config.restic_exclude_file
local aws_s3_url         = util.exit_if_error(restic.restic_get_repository_path(config))

-- get repository secrets
local aws_access_key,
aws_secret_access_key,
repository_secret        = util.exit_if_error(restic.get_repository_secrets())

local environment_table  = {
  "RESTIC_PASSWORD=" .. repository_secret .. " \\",
  "AWS_ACCESS_KEY_ID=" .. aws_access_key .. " \\",
  "AWS_SECRET_ACCESS_KEY=" .. aws_secret_access_key .. " \\",
  "RESTIC_REPOSITORY=" .. aws_s3_url .. " \\"
}
local environment        = table.concat(environment_table, "\n")

local restic_flags_table = {
  "--verbose",
  "backup",
  "--exclude-file=" .. exclude_file,
  "--one-file-system",
  "--exclude-if-present .resticignore " -- append space intentional for last flag
}
local restic_flags       = table.concat(restic_flags_table, " ")

local function write_script(command_string)
  local file, err = io.open(config.restic_backup_shell_script_path, "w")
  if err ~= nil then
    print(err)
    os.exit(1, true)
  end

  if file then
    file:write(command_string)
    file:close()
    print("wrote file to " .. config.restic_backup_shell_script_path)
  end

  -- Change the file permissions to make it executable
  local success, chmod_err = os.execute("chmod 700 " .. config.restic_backup_shell_script_path)
  if not success then
    print("Error making file executable: " .. chmod_err)
    os.exit(1, true)
  end

  -- Change the ownership to 'root:root'
  local success_chown, chown_err = os.execute("chown root:root " .. config.restic_backup_shell_script_path)
  if not success_chown then
    print("Error changing ownership: " .. chown_err)
    os.exit(1, true)
  end
end

local command = environment .. "restic " .. restic_flags .. config.restic_backup_targets
write_script(command)
