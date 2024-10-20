#!/usr/bin/lua
local util = require("script-utils")
local restic = require("restic-utils")

local config = nil
local aws_s3_url = nil

local function print_help()
  print([[
Usage: lua restic-env.lua [--help]

Set up environment variables for Restic to interact with AWS S3.

Example usage:
  eval $(lua restic-env.lua) restic stats

Flags:
  --help    Show this help message.
]])
  os.exit(0)
end

if #arg > 0 and arg[1] == "--help" then
  print_help()
end

config                  = util.exit_if_error(restic.restic_read_config())
aws_s3_url              = util.exit_if_error(restic.restic_get_repository_path(config))

-- get repository secrets
local aws_access_key,
aws_secret_access_key,
repository_secret       = util.exit_if_error(restic.get_repository_secrets())

local environment_table = {
  "RESTIC_PASSWORD=" .. repository_secret,
  "AWS_ACCESS_KEY_ID=" .. aws_access_key,
  "AWS_SECRET_ACCESS_KEY=" .. aws_secret_access_key,
  "RESTIC_REPOSITORY=" .. aws_s3_url,
}
local environment       = table.concat(environment_table, " ")

print(environment)
