# Production deployment

Target allocation:

- domain: `zyf2045.campusmeow.com`
- Compose project: `campusmeow-zyf2045`
- API loopback port: `18045`
- MySQL SSH-tunnel port: `13345`
- MongoDB SSH-tunnel port: `27045`
- shared edge network: `zyf2045-edge`

The production stack deliberately omits Redis because it is not used by the
application and the shared server has limited available memory. MySQL and
MongoDB are reachable only through loopback ports and must be managed through
an SSH tunnel.

## First deployment

```sh
git clone <repository-url> ~/campusmeow-zyf2045
cd ~/campusmeow-zyf2045
cp .env.production.example .env
chmod 600 .env
```

Replace every placeholder in `.env` with independently generated values:

```sh
openssl rand -hex 24
openssl rand -hex 32
```

Then deploy:

```sh
sh deploy.sh up
sh deploy.sh status
curl http://127.0.0.1:18045/actuator/health
```

The script creates only the unique `zyf2045-edge` network and the
`campusmeow-zyf2045` Compose project. It never edits or restarts the shared
Nginx container.

## Shared Nginx

After the API is healthy, connect the shared Nginx container once:

```sh
docker network connect zyf2045-edge campus-nginx
```

An administrator may insert `deploy/nginx/zyf2045.conf` inside the shared
`http { ... }` block. Always validate before reloading:

```sh
docker exec campus-nginx nginx -t
docker exec campus-nginx nginx -s reload
```

Do not restart or recreate the shared Nginx container.

## Updates

```sh
git pull --ff-only
sh deploy.sh up
```

## Database tunnels

```sh
ssh -L 13345:127.0.0.1:13345 ubuntu@106.53.116.230
ssh -L 27045:127.0.0.1:27045 ubuntu@106.53.116.230
```
