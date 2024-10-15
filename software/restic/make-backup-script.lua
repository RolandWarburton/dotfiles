#!/usr/bin/lua
local util     = require("script-utils")
local restic   = require("restic-utils")
local home_dir = os.getenv("HOME")

local home     = function(p)
  return home_dir .. p
end

local hostname = util.exec("/bin/hostname")
if hostname == "" or hostname == nil then
  print("failed to get hostname")
  os.exit(1, true)
end

local config, err = restic.restic_read_config()
if err ~= nil or config == nil then
  print(err)
  return os.exit(1)
end
if config.aws_s3_url == nil then return os.exit(1) end

---------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
local aws_s3_url             = config.aws_s3_url .. "restic-archive-" .. hostname
local backup_targets         = { "/home", "/etc", "/opt", "/root" }
local backup_script_path     = home_dir .. "/.local/bin/restic-backup.sh"
---------------------------------------------------------------------------------------------------

-- create a string of targets to give to restic
local backup_target          = table.concat(backup_targets, " ")

-- location of the exclude file
local exclude_file           = home("/.config/restic/exclude")

-- get AWS secrets
local aws_access_key_id      = util.exec("sudo cat ~/.restic/secrets | yq -r '.aws_access_key'")
local aws_secret_access_key  = util.exec("sudo cat ~/.restic/secrets | yq -r '.aws_secret_access_key'")

-- get repository secret
local repository_secret, err = restic.extract_repository_secret()
if err ~= nil or repository_secret == nil then os.exit(1, true) end

local environment =
    "RESTIC_PASSWORD=" .. repository_secret .. " \\ \n" ..
    "AWS_ACCESS_KEY_ID=" .. aws_access_key_id .. " \\ \n" ..
    "AWS_SECRET_ACCESS_KEY=" .. aws_secret_access_key .. " \\ \n" ..
    "RESTIC_REPOSITORY=" .. aws_s3_url .. " \\ \n"

local restic_flags = {
  "--verbose",
  "backup",
  "--exclude-file=" .. exclude_file,
  "--exclude-if-present .resticignore " -- append space intentional
}

local command = environment .. "restic " .. table.concat(restic_flags, " ") .. backup_target

local file = io.open(backup_script_path, "w")
if file then
  file:write(command)
  file:close()
end

print()
