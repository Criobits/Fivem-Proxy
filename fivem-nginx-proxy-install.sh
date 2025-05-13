#!/bin/bash

# Improved OS detection
OS="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
fi

# Must be root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Install nginx
install_nginx() {
    case "$1" in
        debian|ubuntu)
            apt-get update
            apt-get install -y gnupg2 lsb-release software-properties-common wget
            OS_CODENAME=$(lsb_release -cs)
            echo "deb http://nginx.org/packages/mainline/ubuntu/ $OS_CODENAME nginx" \
                > /etc/apt/sources.list.d/nginx.list
            echo "deb-src http://nginx.org/packages/mainline/ubuntu/ $OS_CODENAME nginx" \
                >> /etc/apt/sources.list.d/nginx.list
            wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add -
            apt-get update
            apt-get install -y nginx
            ;;
        centos|fedora|rhel)
            yum install -y epel-release yum-utils wget
            yum-config-manager --add-repo http://nginx.org/packages/mainline/centos/7/x86_64/
            wget -qO - http://nginx.org/keys/nginx_signing.key | rpm --import -
            yum install -y nginx
            ;;
        *)
            echo "Unsupported OS: $1" >&2
            exit 1
            ;;
    esac

    systemctl enable nginx
    systemctl start nginx
}

install_nginx "$OS"

# Remove old configs and SSL dir (not needed)
rm -rf /etc/nginx/conf.d
rm -rf /etc/nginx/ssl 2>/dev/null

# Ask for backend IP and HTTP domain
read -rp "Enter your game server IP (e.g. 1.2.3.4): " SERVER_IP
read -rp "Enter your HTTP domain (e.g. play.example.com): " DOMAIN

# Download fresh configs
wget -q \
  https://raw.githubusercontent.com/Criobits/Fivem-Proxy/refs/heads/main/files/nginx.conf \
  -O /etc/nginx/nginx.conf

wget -q \
  https://raw.githubusercontent.com/Criobits/Fivem-Proxy/refs/heads/main/files/cloudflare.conf \
  -O /etc/nginx/cloudflare.conf

wget -q \
  https://raw.githubusercontent.com/Criobits/Fivem-Proxy/refs/heads/main/files/web.conf \
  -O /etc/nginx/web.conf

wget -q \
  https://raw.githubusercontent.com/Criobits/Fivem-Proxy/refs/heads/main/files/stream.conf \
  -O /etc/nginx/stream.conf

# Patch in your IP and domain
sed -i "s/ip_goes_here/${SERVER_IP}/g" /etc/nginx/nginx.conf
sed -i "s/server_name_goes_here/${DOMAIN}/g"   /etc/nginx/web.conf
sed -i "s/ip_goes_here/${SERVER_IP}:30120/g"  /etc/nginx/stream.conf

# Restart nginx to apply
systemctl restart nginx

echo
echo "✅ nginx is now live!"
echo "- HTTP on port 80 → http://${DOMAIN}"
echo "- Game traffic on 30120 → ${SERVER_IP}:30120"
echo


exit 0
