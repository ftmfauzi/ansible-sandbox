#!/bin/bash

# This script installs the NGINX Prometheus Exporter on a Linux system.
set -e
set -x

VERSION="1.4.1"
ARCH="linux_amd64"
EXPORTER_USER="nginx_exporter"
EXPORTER_BIN="/usr/local/bin/nginx-prometheus-exporter"
EXPORTER_SERVICE="/etc/systemd/system/nginx_prometheus_exporter.service"
SCRAPE_PORT=9113

# 1. Create user
if ! id "$EXPORTER_USER" &>/dev/null; then
  sudo useradd --system --no-create-home --shell /sbin/nologin "$EXPORTER_USER"
fi

# 2. Download exporter
cd /tmp
wget -O nginx-prometheus-exporter.tar.gz "https://github.com/nginx/nginx-prometheus-exporter/releases/download/v${VERSION}/nginx-prometheus-exporter_${VERSION}_${ARCH}.tar.gz"

# 3. Extract
mkdir -p /tmp/nginx-exporter
tar -xvzf  nginx-prometheus-exporter.tar.gz -C /tmp/nginx-exporter
sudo mv /tmp/nginx-exporter/nginx-prometheus-exporter "$EXPORTER_BIN"
sudo chmod +x "$EXPORTER_BIN"

# 4. Create systemd service
sudo tee "$EXPORTER_SERVICE" > /dev/null <<EOF
[Unit]
Description=Nginx Prometheus Exporter
After=network.target

[Service]
User=$EXPORTER_USER
ExecStart=$EXPORTER_BIN -nginx.scrape-uri http://localhost:8088/nginx_status
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 5. Reload systemd and enable service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nginx_prometheus_exporter
sudo systemctl start nginx_prometheus_exporter

# 6. Create nginx-status.conf for stub_status
sudo tee /etc/nginx/conf.d/nginx-status.conf > /dev/null <<EOF
server {
    listen 8088;
    location = /nginx_status {
        stub_status;
    }
}
EOF

# 7. Test and reload NGINX
sudo nginx -t && sudo systemctl reload nginx

# 8. Verify
curl -f http://localhost:$SCRAPE_PORT/metrics || echo "❌ Exporter gagal jalan!"
curl -f http://localhost:8088/nginx_status || echo "❌ NGINX status gagal jalan!"