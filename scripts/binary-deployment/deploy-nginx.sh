#!/usr/bin/env bash
set -euo pipefail

# Source environment variables if env_vars file exists
if [ -f ~/bins/nginx-deployment/env_vars ]; then
  source ~/bins/nginx-deployment/env_vars
fi

sudo apt-get update
sudo apt-get install -y "nginx=$NGINX_VERSION-*" || sudo apt-get install -y nginx

if systemctl is-active --quiet nginx; then
    sudo systemctl stop nginx
fi

sudo systemctl start nginx
