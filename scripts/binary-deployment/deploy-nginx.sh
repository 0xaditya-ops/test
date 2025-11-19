#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y "nginx=$NGINX_VERSION-*" || sudo apt-get install -y nginx

if systemctl is-active --quiet nginx; then
    sudo systemctl stop nginx
fi

sudo systemctl start nginx
