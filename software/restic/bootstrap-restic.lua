#!/usr/bin/lua

local lyaml = require("lyaml")
local util = require("script-utils")
local restic = require("restic-utils")

-- home directory
local home_dir = os.getenv("HOME")

---------------------------------------------------------------------------------------------------
-- ATTENTION: SCRIPT VARIABLES
local restic_backup_dir = home_dir .. "/.restic"        -- location for restic repository
local aws_secrets_path = home_dir .. "/.restic/secrets" -- aws secrets location
local restic_config_dir = home_dir .. "/.config/restic" -- config files about restic
local aws_s3_url = "s3:s3.ap-southeast-2.amazonaws.com/aws-restic-archive"
---------------------------------------------------------------------------------------------------

util.two_col("[INFO] RESTIC BACKUP DIRECTORY", restic_backup_dir)
util.two_col("[INFO] AWS SECRETS PATH ", aws_secrets_path)
util.two_col("[INFO] AWS BUCKET ", aws_s3_url)

local exit_if_error = function(err)
  if err ~= nil then
    print(err)
    os.exit(1, true)
  end
end

local err = nil

-- ensure that the restic backup repository is empty to avoid overwriting any files
err = restic.restic_folder_exists(restic_backup_dir)
exit_if_error(err)

err = restic.restic_folder_is_empty(restic_backup_dir)
exit_if_error(err)

-- create the restic backup repository location exists
os.execute("mkdir -p " .. restic_backup_dir)
util.two_col("[OK] created backup dir ", restic_backup_dir)

-- ensure that the restic config exists
err = restic.restic_config_exists(restic_config_dir)
if err ~= nil then
  print(err)
  os.exit(1, true)
end

-- get the restic AWS keys
local aws_secrets, errmsg = restic.extract_aws_secrets()
if errmsg ~= nil or aws_secrets == nil then
  print(errmsg)
  os.exit(1, true)
end

-- wrap the data in an AWS object
local aws_secrets_data = {
  {
    aws = {
      access_key = aws_secrets.access_key,
      secret_access_key = aws_secrets.secret_access_key
    }
  }
}

-- write the AWS keys for restic backup to a file
local file, err = io.open(aws_secrets_path, "w")
if not file then
  print("[ERROR] Failed to open file: " .. err)
  os.exit(1)
end
file:write(lyaml.dump(aws_secrets_data))
file:close()
print("Settings permissions for " .. aws_secrets_path)
os.execute("sudo chown root:root " .. aws_secrets_path)
os.execute("sudo chmod 600 " .. aws_secrets_path)
util.two_col("[OK] written aws secrets", aws_secrets_path)

-- get the repository secret
local repository_secret = nil
repository_secret, err = restic.extract_repository_secret()
if err or not repository_secret then
  print(err)
  os.exit(1, true)
else
  print("[OK] read repository password from password store")
end

local restic_repository = restic_backup_dir .. "/" .. aws_s3_url
local environment = "RESTIC_PASSWORD=" .. repository_secret .. " " ..
    "AWS_ACCESS_KEY_ID=" .. aws_secrets.access_key .. " " ..
    "AWS_SECRET_ACCESS_KEY=" .. aws_secrets.secret_access_key .. " " ..
    "RESTIC_REPOSITORY=" .. restic_repository

-- create the repository
local command = string.format(
  "cd %s; %s restic init",
  restic_backup_dir,
  environment
)
print(command)
local result, exit_code = util.exec(command)
if exit_code ~= 0 then
  print("something went wrong creating the repository")
else
  print(result)
end
