#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_VARS_FILE="$SCRIPT_DIR/env_vars"

# Source environment variables if env_vars file exists
if [ -f "$ENV_VARS_FILE" ]; then
  source "$ENV_VARS_FILE"
fi

# Validate NGINX_VERSION is set
if [ -z "${NGINX_VERSION:-}" ]; then
  echo "ERROR: NGINX_VERSION is not set"
  exit 1
fi

# Stop and remove existing nginx container if it exists
if docker ps -a --format '{{.Names}}' | grep -q '^nginx$'; then
  echo "Stopping and removing existing nginx container..."
  docker stop nginx || true
  docker rm nginx || true
fi

# Pull the specific nginx version
echo "Pulling nginx:${NGINX_VERSION}..."
docker pull "nginx:${NGINX_VERSION}"

# Run nginx container with restart policy
echo "Starting nginx container..."
docker run -d \
  --name nginx \
  --restart unless-stopped \
  -p 80:80 \
  "nginx:${NGINX_VERSION}"

# Verify container is running
sleep 2
if docker ps --format '{{.Names}}' | grep -q '^nginx$'; then
  echo "Successfully deployed nginx:${NGINX_VERSION}"
  docker ps --filter name=nginx --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
  echo "ERROR: nginx container failed to start"
  docker logs nginx
  exit 1
fi
