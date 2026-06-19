#!/bin/bash
set -e
set -o pipefail

exec > >(tee /var/log/user-data-backend.log | logger -t user-data-backend -s 2>/dev/console) 2>&1

APP_DIR="/opt/relatos-backend"

if command -v dnf >/dev/null 2>&1; then
  dnf update -y
  dnf install -y python3
elif command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y python3
else
  echo "No supported package manager found. Expected dnf or yum."
  exit 1
fi

mkdir -p "$APP_DIR"

cat >"$APP_DIR/app.py" <<'PYAPP'
from http.server import BaseHTTPRequestHandler, HTTPServer
import json


class RelatosBackendHandler(BaseHTTPRequestHandler):
    def _send_json(self, status_code, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/health":
            self._send_json(200, {"status": "UP", "service": "backend"})
            return

        if self.path == "/api" or self.path.startswith("/api/") or self.path.startswith("/api?"):
            self._send_json(
                200,
                {
                    "message": "API de prueba de Relatos de Papel",
                    "service": "backend",
                    "status": "OK",
                },
            )
            return

        self._send_json(404, {"error": "Not found"})

    def log_message(self, format, *args):
        print("%s - - [%s] %s" % (self.address_string(), self.log_date_time_string(), format % args))


if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), RelatosBackendHandler)
    print("Relatos de Papel backend listening on 0.0.0.0:8080")
    server.serve_forever()
PYAPP

cat >/etc/systemd/system/relatos-backend.service <<'SYSTEMD'
[Unit]
Description=Relatos de Papel backend API
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/relatos-backend
ExecStart=/usr/bin/python3 /opt/relatos-backend/app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SYSTEMD

systemctl daemon-reload
systemctl enable relatos-backend.service
systemctl start relatos-backend.service
