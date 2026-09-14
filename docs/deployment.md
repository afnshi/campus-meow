# CampusMeow：Ubuntu 24.04 部署

域名为 `www.afnshi.cn`，服务器为 `ubuntu@1.14.194.211`。
使用宿主机 Nginx，保留旧项目 `citrus` 的配置、页面目录和 8000 端口服务。
项目目录约定为 `~/campusmeow`，Web 目录为 `/var/www/campusmeow`。

Compose 项目名 `campusmeow-zyf2045` 和网络名保持兼容；它们不决定域名。
API 仅发布到 `127.0.0.1:18045`，MySQL 和 MongoDB 仅发布到本机 13345、27045。
宿主机 Nginx 不需要加入 Docker 网络。旧 `deploy/nginx/zyf2045.conf` 本次不启用。
容器内存限额合计 1 GiB，已有服务、系统和构建还需要额外资源。生产配置暂不启动 Redis。

## 本地构建

在仓库根目录、能使用 Flutter 的 POSIX shell 中执行：

```sh
API_BASE_URL=https://www.afnshi.cn/api/v1 sh build.sh web
```

环境变量指定客户端的生产接口；`web` 只构建 Web，输出到 `dist/web`。
脚本也支持 `jar`、`apk`、`all`，默认 `all`；未指定接口时沿用本地开发地址。
正式 APK 也需传入生产接口地址。Web 输出目录每次构建成功后会重新生成。

Windows PowerShell 可以直接使用本机 Flutter：

```powershell
Set-Location E:\codex\practice\apps\flutter_client
flutter build web --release --dart-define=API_BASE_URL=https://www.afnshi.cn/api/v1
```

第一条切换客户端目录；第二条编译发布版并传入接口地址。
直接调用 Flutter 的产物位于 `apps/flutter_client/build/web`，不会复制到 `dist/web`。

## 上传与启动后端

将代码上传或克隆到服务器 `~/campusmeow`，不要上传本地 `.env`、私钥或依赖缓存。
Web 产物另外上传到服务器 `~/campusmeow/dist/web`，确保该目录直接包含 `index.html`。
构建产物不包含在 Git 中。

以下命令在服务器执行：

```sh
cd ~/campusmeow
if [ ! -e .env ]; then
  (umask 077; cp .env.production.example .env)
fi
chmod 600 .env
nano .env
```

进入项目，仅在不存在时创建环境文件，限制为所有者读写，再打开编辑器。
分别替换所有密码及 JWT 占位值。已有数据库初始化后，保留对应的原密码。

```sh
openssl rand -hex 24
openssl rand -hex 32
```

第一条生成随机密码，每个密码独立执行一次；第二条生成 JWT 密钥。不要分享或提交这些值。

```sh
sudo sh deploy.sh up
sudo sh deploy.sh status
curl -fsS http://127.0.0.1:18045/actuator/health
```

分别构建并启动服务、显示容器状态、检查后端健康，预期包含 `UP`。
当前用户没有 Docker 权限时使用 `sudo`。

## 首次启用新网站

确认 A 记录正确，公网 80/443 可达，且其他配置没有占用 `server_name www.afnshi.cn`。
以下路径专属新项目，不修改旧项目 `citrus`。

```sh
sudo install -d -m 755 /var/www/campusmeow
sudo cp -R dist/web/. /var/www/campusmeow/
sudo find /var/www/campusmeow -type d -exec chmod 755 {} \;
sudo find /var/www/campusmeow -type f -exec chmod 644 {} \;
```

创建目录、复制 Web 文件，并设置 Nginx 可读取的目录和文件权限。

```sh
sudo cp -n deploy/nginx/campusmeow.conf /etc/nginx/sites-available/campusmeow
sudo ln -s /etc/nginx/sites-available/campusmeow /etc/nginx/sites-enabled/campusmeow
sudo nginx -t && sudo systemctl reload nginx
```

复制独立配置（`-n` 不覆盖已有文件），创建软链接启用网站，语法检查通过后平滑重载。
若目标文件或链接已存在，先检查内容，不要强制覆盖。保留 `citrus` 链接。

```sh
curl -I http://www.afnshi.cn
```

查看 HTTP 响应头，再在电脑浏览器确认页面属于 CampusMeow。
生产客户端使用 HTTPS API，登录等完整验证需等下一步完成。

## HTTPS

```sh
sudo apt update
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d www.afnshi.cn --redirect
```

更新软件索引、安装证书工具及 Nginx 插件，申请证书并添加 HTTPS 和 HTTP 跳转。
按提示填写邮箱和接受条款。HTTP 验证要求公网可访问 80 端口。
Certbot 修改的是服务器上的配置；证书、私钥留在服务器，不提交到 Git。

```sh
curl -I https://www.afnshi.cn
sudo systemctl enable --now certbot.timer
sudo certbot renew --dry-run
```

验证 HTTPS、启用续期定时器并模拟续期；不要用 `curl -k` 跳过证书检查。
最后在浏览器验证注册、登录等核心功能。

## 更新和排查

更新代码后用 `sudo sh deploy.sh up` 重建后端。
重新构建上传 Web 后，将其文件复制到 `/var/www/campusmeow`。
不要再次用仓库中的 HTTP 模板覆盖 Certbot 修改后的配置。
修改 Nginx 前备份服务器上的配置，检查成功后再重载。

```sh
sudo docker compose -p campusmeow-zyf2045 -f docker-compose.prod.yml logs --tail=100
```

查看该项目最近的容器日志；分享前检查是否包含秘密。

## SSH 数据库隧道

在自己电脑执行：

```sh
ssh -N -L 13345:127.0.0.1:13345 -L 27045:127.0.0.1:27045 ubuntu@1.14.194.211
```

`-N` 只建立隧道，两个 `-L` 分别转发数据库端口；保持终端打开，客户端连接本机对应端口。
无需向公网开放数据库端口。
