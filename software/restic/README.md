# RESTIC BACKUP

Documentation for my restic backup solution about how it is assembled.
The purpose of this document is to explain the different parts for future reference & maintenance.

TLDR: run `bootstrap-restic.lua` and then run the generated backup script.

```bash
# Create a new repository
sudo -E LUA_PATH="$LUA_PATH;$HOME/.luarocks/share/lua/5.1/?/init.lua" \
lua bootstrap-restic.lua

# Run generate-backup-script
sudo -E LUA_PATH="$LUA_PATH;$HOME/.luarocks/share/lua/5.1/?/init.lua" \
lua make-backup-script.lua

# Run backup script
sudo /usr/local/bin/restic-backup.sh
```

Running restic commands can be done by evaluating `restic-env.lua`
which will populate your command with the required environment variables.

```bash
eval $(lua restic-env.lua) restic stats
```

## Configuration

Variables are read in from `~/.config/restic/config.yaml`.

```yaml
restic_backup_dir: /home/roland/.restic
restic_secrets_path: /home/roland/.restic/secrets
restic_backup_shell_script_path: /usr/local/bin/restic-backup.sh
restic_backup_targets: '/home /etc /opt /root /usr'
restic_exclude_file: /home/roland/.config/restic/exclude
aws_s3_url: 's3:https://PLACEHOLDER.net/'
bucket_name: restic-archive-PLACEHOLDER
```

## Secrets

Secrets are read from [pass](https://www.passwordstore.org/) in `restic/secrets` in a YAML format.

The minimum required secrets are below. Be sure to replace `_HOSTNAME_` with a real hostname.

```yaml
hosts:
  _HOSTNAME_:
    password: PLACEHOLDER
aws:
  access_key: PLACEHOLDER
  secret_access_key: PLACEHOLDER
```

## Creating New Restic Archives

### MINIO Object Store

I back up most of my things to a MINIO instance in a VPS.

<details>
<summary>Click to expand policy</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::*"]
    },
    {
      "Effect": "Allow",
      "Action": ["s3:DeleteObject", "s3:GetObject", "s3:PutObject"],
      "Resource": ["arn:aws:s3:::restic-archive*/*"]
    }
  ]
}
```

</details>

A bucket should pre-exist for each restic repository named `restic-archive-%HOSTNAME%`.

### Bootstrapping Script

This section details the `bootstrap.lua` script.

Bootstrapping the restic repository requires these parts.

- File `bootstrap.lua` currently located in this directory
- Module `restic-utils` currently located in `.local/luarocks/5.1/restic-utils` of this repository
- Module `script-utils` currently located in `.local/luarocks/5.1/script-utils` of this repository
- Config file `ignore` currently located in `.config/restic/` of this repository (OPTIONAL)

High level pseudo-code for `bootstrap-restic.lua` is below.

```none
create restic_backup_dir
read aws_secrets, and repo_secret from password store
write aws_secrets and repo_secret to a file in the restic_backup_dir
create repository with provded aws_secrets, repo_secret, and aws_s3_url
```

This should create a directory in the `restic_backup_dir`
with a `secrets` file that restic can use for future automated backups.
