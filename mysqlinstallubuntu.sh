#!/bin/bash

set -e

echo "========================================"
echo " MySQL Installation Script for Ubuntu "
echo "========================================"

# Check Ubuntu
if [ ! -f /etc/os-release ]; then
    echo "Unsupported Linux"
    exit 1
fi

source /etc/os-release

if [ "$ID" != "ubuntu" ]; then
    echo "This script supports Ubuntu only."
    exit 1
fi

CODENAME=$(lsb_release -cs)

case "$CODENAME" in
    focal|jammy|noble)
        ;;
    *)
        echo "Unsupported Ubuntu Version: $CODENAME"
        exit 1
        ;;
esac

echo "Detected Ubuntu: $CODENAME"

sudo apt update

sudo apt install -y \
curl \
wget \
gnupg \
lsb-release \
ca-certificates

echo "Removing old MySQL Repository..."

sudo rm -f /etc/apt/sources.list.d/mysql.list
sudo rm -f /usr/share/keyrings/mysql.gpg

echo "Downloading Oracle MySQL GPG Key..."

curl -fsSL https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | \
sudo gpg --dearmor -o /usr/share/keyrings/mysql.gpg

echo "Adding Repository..."

echo "deb [signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu $CODENAME mysql-8.4-lts" | \
sudo tee /etc/apt/sources.list.d/mysql.list

sudo apt update

echo "Installing MySQL..."

sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-community-server

echo "Starting MySQL..."

sudo systemctl enable mysql
sudo systemctl start mysql

echo

mysql --version

echo

sudo systemctl status mysql --no-pager

echo
echo "Installation Completed Successfully."
