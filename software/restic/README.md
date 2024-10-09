# RESTIC BACKUP

Documentation for my restic backup solution about how it is assembled.
The purpose of this document is to explain the different parts for future reference & maintenance.

## Configuration

Variables are read in from `~/.config/restic/config.yaml`.

- `restic_backup_dir` location separate to .config to store generated secrets and logs
- `aws_s3_url` location to backup to, example `s3:http://localhost:9000/`. The hostname is appended

## Secrets

We require three secrets.
Secrets are read from [pass](https://www.passwordstore.org/) in `restic/*`.

- AWS access key
- AWS secret access key
- Repository password

There should be a `minio` entry containing yaml for the AWS secrets.

```yaml
# shell$ pass restic/minio
secrets:
  access_key: PLACEHOLDER
  secret_access_key: PLACEHOLDER
```

There should also be an entry for each repository secret under the device hostname

```bash
# shell$ pass restic/my_host_name
mysecret
```

## Creating New Restic Archives

### MINIO Object Store

I back up most of my things to a MINIO instance in a VPS.

I use these access keys with the below policy.

<details>
<summary>Click to expand policy</summary>

```json
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Action": [
    "s3:ListBucket"
   ],
   "Resource": [
    "arn:aws:s3:::*"
   ]
  },
  {
   "Effect": "Allow",
   "Action": [
    "s3:DeleteObject",
    "s3:GetObject",
    "s3:PutObject"
   ],
   "Resource": [
    "arn:aws:s3:::restic-archive*/*"
   ]
  }
 ]
}
```

</details>

### Bootstrapping script

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
