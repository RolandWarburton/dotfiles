#!/usr/bin/lua

local util = require("script-utils")
local restic = require("restic-utils")

local config = nil
config = util.exit_if_error(restic.restic_read_config())

local hostname = util.exec("/bin/hostname")
if hostname == "" or hostname == nil then
  print("failed to get hostname")
  os.exit(1, true)
end

-- set these script variables based on the restic config file
local restic_backup_dir = config.restic_backup_dir              -- location for restic repository
local aws_s3_url = util.exit_if_error(restic.restic_get_repository_path(config))
local aws_secrets_path = config.restic_backup_dir .. "/secrets" -- aws secrets location

util.two_col("[INFO] RESTIC BACKUP DIRECTORY", restic_backup_dir)
util.two_col("[INFO] AWS SECRETS PATH ", aws_secrets_path)
util.two_col("[INFO] REPOSITORY PATH ", aws_s3_url)

-- get repository secrets
local aws_access_key,
aws_secret_access_key,
repository_secret = util.exit_if_error(restic.get_repository_secrets())

-- set environment for command
local environment =
    "RESTIC_PASSWORD=" .. repository_secret .. " " ..
    "AWS_ACCESS_KEY_ID=" .. aws_access_key .. " " ..
    "AWS_SECRET_ACCESS_KEY=" .. aws_secret_access_key .. " " ..
    "RESTIC_REPOSITORY=" .. aws_s3_url

-- create the repository
local command     = string.format("%s restic init", environment)
print(command)
local result, exit_code = util.exec(command)
if exit_code ~= 0 then
  print("something went wrong creating the repository")
else
  print(result)
end
