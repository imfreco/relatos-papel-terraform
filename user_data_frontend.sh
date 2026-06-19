#!/bin/bash
set -e
set -o pipefail

exec > >(tee /var/log/user-data-frontend.log | logger -t user-data-frontend -s 2>/dev/console) 2>&1

PROJECT_DIR="/home/ec2-user/proyecto"
HTML_DIR="/usr/share/nginx/html"
ZIP_FILE="/tmp/relatos-papel-frontend.zip"
COOKIE_FILE="/tmp/relatos-papel-google-drive-cookies.txt"
GOOGLE_DRIVE_FILE_ID="${google_drive_file_id}"
DOWNLOAD_URL="https://drive.google.com/uc?export=download&id=${google_drive_file_id}"

if command -v dnf >/dev/null 2>&1; then
  dnf update -y
  dnf install -y nginx wget unzip
elif command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y nginx wget unzip
else
  echo "No supported package manager found. Expected dnf or yum."
  exit 1
fi

systemctl enable nginx
systemctl start nginx

mkdir -p "$PROJECT_DIR" "$HTML_DIR"
chown -R ec2-user:ec2-user "$PROJECT_DIR"

echo "Downloading frontend artifact from Google Drive file ID: $GOOGLE_DRIVE_FILE_ID"
CONFIRM_TOKEN=$(wget --quiet --save-cookies "$COOKIE_FILE" --keep-session-cookies "$DOWNLOAD_URL" -O - | sed -rn 's/.*confirm=([0-9A-Za-z_-]+).*/\1/p' | head -n 1 || true)

if [ -n "$CONFIRM_TOKEN" ]; then
  wget --no-verbose --load-cookies "$COOKIE_FILE" --output-document="$ZIP_FILE" "https://drive.google.com/uc?export=download&confirm=$CONFIRM_TOKEN&id=$GOOGLE_DRIVE_FILE_ID"
else
  wget --no-verbose --output-document="$ZIP_FILE" "$DOWNLOAD_URL"
fi

rm -rf "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
unzip -o "$ZIP_FILE" -d "$PROJECT_DIR"
chown -R ec2-user:ec2-user "$PROJECT_DIR"

DIST_DIR=$(find "$PROJECT_DIR" -type d -name dist | head -n 1)

if [ -z "$DIST_DIR" ]; then
  echo "No dist directory found inside the frontend ZIP artifact."
  exit 1
fi

find "$HTML_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
cp -a "$DIST_DIR"/. "$HTML_DIR"/
printf 'OK\n' > "$HTML_DIR/health"

cat >/etc/nginx/conf.d/react-app.conf <<'NGINXCONF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location = /health {
        default_type text/plain;
        return 200 "OK\n";
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINXCONF

nginx -t
systemctl restart nginx
