#!/bin/bash
set -euo pipefail

LOGFILE="/var/log/vm-identity-cloud-init.log"

function log {
  local level="$1"
  local message="$2"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local log_entry="$timestamp [$level] - $message"

  echo "$log_entry" | tee -a "$LOGFILE"
}

HOSTNAME=$(hostname)
OS=$(source /etc/os-release && echo "$PRETTY_NAME")
MEMORY=$(free -h | awk '/^Mem:/ {print $2}')
VCPUS=$(nproc)
ARCH=$(uname -m)
PUBLIC_IP=$(curl ifconfig.me || echo "N/A")

log "INFO" "Beginning VM Identity web app bootstrap script"

log "INFO" "Installing nginx"
sudo apt-get update -y
sudo apt-get install -y nginx

log "INFO" "Creating web directory and copying files"
sudo mkdir -p /usr/share/nginx/html/vm-identity
sudo cp /tmp/index.html /usr/share/nginx/html/vm-identity/
sudo cp /tmp/style.css /usr/share/nginx/html/vm-identity/

HTML_FILE="/usr/share/nginx/html/vm-identity/index.html"

sudo sed -i \
  -e "s|{hostname}|$HOSTNAME|g" \
  -e "s|{os}|$OS|g" \
  -e "s|{memory}|$MEMORY|g" \
  -e "s|{vcpus}|$VCPUS|g" \
  -e "s|{arch}|$ARCH|g" \
  -e "s|{public_ip}|$PUBLIC_IP|g" \
  "$HTML_FILE"

log "INFO" "Configuring nginx"
sudo tee /etc/nginx/conf.d/vm-identity.conf > /dev/null <<'EOF'
server {
    listen 80;
    listen [::]:80;
    
    root /usr/share/nginx/html/vm-identity;
    index index.html;
    
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

log "INFO" "Removing default nginx configs"
sudo rm -f /etc/nginx/conf.d/default.conf
sudo rm -f /etc/nginx/sites-enabled/default

log "INFO" "Validating nginx config"
sudo nginx -t

log "INFO" "Enabling and restarting nginx service"
sudo systemctl enable nginx
sudo systemctl restart nginx

log "INFO" "VM Identity web app is now running on port 80"
