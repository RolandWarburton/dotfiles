# MINIO Setup Notes

This section describes how to create a minio instance using nginx and letsencrypt.

## Installing Software

Ensure you have installed minio server and its command line client.
Place these executable files somewhere in your PATH with execution permission.

```bash
wget https://dl.min.io/enterprise/minio/release/linux-amd64/minio
wget https://dl.min.io/client/mc/release/linux-amd64/mc
```

## Starting MINIO

Allow the minio binary to allow access to privileged ports when run as an unprivileged user.

```bash
sudo setcap 'cap_net_bind_service=+ep' $(which minio)
```

Starting minio can be done by simply executing the binary and providing some configuration flags.
You can visit the console at [ http://localhost:9001 ](http://localhost:9001)

```bash
MINIO_BROWSER_REDIRECT_URL=http://minio.EXAMPLE.net/minio/ui \
MINIO_ROOT_USER=EXAMPLE \
MINIO_ROOT_PASSWORD=EXAMPLE \
minio server /mnt/data --console-address "127.0.0.1:9001" --address "127.0.0.1:9000" \
```

## NGINX: Terminate TLS And Proxy to MINIO

Next lets setup https to secure connections to the console and server.

Get a letsencrypt certificate for your domain using this docker configuration.

<details>
<summary>Click to certbot docker compose file</summary>

Running `docker-compose up` is sufficient and will write certificates to `/etc/letsencrypt`.

Make sure you are updating `--email` and `-d` to set up your email and domain respectively.

```yaml
version: '3'

services:
  certbot:
    image: certbot/certbot
    container_name: certbot
    volumes:
      - /etc/certs:/etc/letsencrypt
    command: certonly --standalone --agree-tos --non-interactive --email my_email@domain.com -d minio.EXAMPLE.net
    ports:
      - '80:80'
      - '443:443'
```

</details>

Then using this configuration from the
[minio documentation](https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html)
create the nginx configuration.

<details>
<summary>Click to certbot docker compose file</summary>

Update the `server_name` for your domain, and review the `ssl_certificate` and `ssl_certificate_key`
are pointing to the correct locations.

```nginx
upstream minio_server {
    server 127.0.0.1:9000;
}

upstream minio_console {
    server 127.0.0.1:9001;
}


server {
  listen 443 ssl;
  server_name  minio.EXAMPLE.net;
  ssl_certificate /etc/letsencrypt/live/minio.EXAMPLE.net/fullchain.pem;  # Path to fullchain.pem
  ssl_certificate_key /etc/letsencrypt/live/minio.EXAMPLE.net/privkey.pem;  # Path to privkey.pem
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!aNULL:!MD5;

   # Allow special characters in headers
   ignore_invalid_headers off;
   # Allow any size file to be uploaded.
   # Set to a value such as 1000m; to restrict file size to a specific value
   client_max_body_size 0;
   # Disable buffering
   proxy_buffering off;
   proxy_request_buffering off;

   location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;

      proxy_pass http://minio_server; # This uses the upstream directive definition to load balance
   }

   location /minio/ui/ {
      rewrite ^/minio/ui/(.*) /$1 break;
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-NginX-Proxy true;

      # This is necessary to pass the correct IP to be hashed
      real_ip_header X-Real-IP;

      proxy_connect_timeout 300;

      # To support websockets in MinIO versions released after January 2023
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      # Some environments may encounter CORS errors (Kubernetes + Nginx Ingress)
      # Uncomment the following line to set the Origin request to an empty string
      # proxy_set_header Origin '';

      chunked_transfer_encoding off;

      proxy_pass http://minio_console; # This uses the upstream directive definition to load balance
   }
}
```

</details>
