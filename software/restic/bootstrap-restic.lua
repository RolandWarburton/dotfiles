#!/usr/bin/lua

local lyaml = require("lyaml")
local util = require("script-utils")
local restic = require("restic-utils")

local err = nil
local config = nil
local repository_secret = nil
local aws_secrets = nil

local exit_if_error = function(err)
  if err ~= nil then
    print(err)
    os.exit(1, true)
  end
end

config, err = restic.restic_read_config()
if err ~= nil or config == nil then
  print(err)
  os.exit(1, true)
end

local hostname = util.exec("/bin/hostname")
if hostname == "" or hostname == nil then
  print("failed to get hostname")
  os.exit(1, true)
end

-- set these script variables based on the restic config file
local restic_backup_dir = config.restic_backup_dir              -- location for restic repository
local aws_s3_url = config.aws_s3_url .. "restic-archive-" .. hostname
local aws_secrets_path = config.restic_backup_dir .. "/secrets" -- aws secrets location

util.two_col("[INFO] RESTIC BACKUP DIRECTORY", restic_backup_dir)
util.two_col("[INFO] AWS SECRETS PATH ", aws_secrets_path)
util.two_col("[INFO] AWS BUCKET ", aws_s3_url)

-- ensure that the restic backup repository is empty to avoid overwriting any files
err = restic.restic_folder_exists(restic_backup_dir)
exit_if_error(err)

err = restic.restic_folder_is_empty(restic_backup_dir)
exit_if_error(err)

-- create the restic backup repository location exists
os.execute("mkdir -p " .. restic_backup_dir)
util.two_col("[OK] created backup dir ", restic_backup_dir)

-- get the restic AWS keys
aws_secrets, err = restic.extract_aws_secrets()
exit_if_error(err)
if aws_secrets == nil then
  exit_if_error("failed to get aws secrets"); return
end

-- get the repository secret
repository_secret, err = restic.extract_repository_secret()
exit_if_error(err)
print("[OK] read repository password from password store")

-- wrap the data in an AWS object
local aws_secrets_data = {
  {
    aws_access_key = aws_secrets.access_key,
    aws_secret_access_key = aws_secrets.secret_access_key,
    repository_secret = repository_secret
  }
}

-- write the secrets to a file
local file = nil
file, err = io.open(aws_secrets_path, "w")
if not file then
  print("[ERROR] Failed to open file: " .. err)
  os.exit(1)
end
file:write(lyaml.dump(aws_secrets_data))
file:close()
print("Setting permissions for " .. aws_secrets_path)
os.execute("sudo chown root:root " .. aws_secrets_path)
os.execute("sudo chmod 600 " .. aws_secrets_path)
util.two_col("[OK] written aws secrets", aws_secrets_path)

local environment =
    "RESTIC_PASSWORD=" .. repository_secret .. " " ..
    "AWS_ACCESS_KEY_ID=" .. aws_secrets.access_key .. " " ..
    "AWS_SECRET_ACCESS_KEY=" .. aws_secrets.secret_access_key .. " " ..
    "RESTIC_REPOSITORY=" .. aws_s3_url

-- create the repository
local command = string.format(
  "%s restic init",
  environment
)
local result, exit_code = util.exec(command)
if exit_code ~= 0 then
  print("something went wrong creating the repository")
else
  print(result)
end
