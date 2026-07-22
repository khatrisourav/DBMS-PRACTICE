#!/bin/bash

set -e

echo "Updating package list..."
sudo apt update

echo "Installing required packages..."
sudo apt install -y curl wget gnupg lsb-release ca-certificates

# Detect Ubuntu codename
CODENAME=$(lsb_release -cs)

echo "Detected Ubuntu Codename: $CODENAME"

# Check supported Ubuntu versions
if [[ "$CODENAME" == "noble" ]]; then
    REPO="noble"
elif [[ "$CODENAME" == "jammy" ]]; then
    REPO="jammy"
elif [[ "$CODENAME" == "focal" ]]; then
    REPO="focal"
else
    echo "❌ Unsupported Ubuntu version: $CODENAME"
    exit 1
fi

echo "Adding MySQL GPG Key..."
curl -fsSL https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | \
sudo gpg --dearmor -o /usr/share/keyrings/mysql.gpg

echo "Adding MySQL Repository..."
echo "deb [signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu $REPO mysql-8.4-lts" | \
sudo tee /etc/apt/sources.list.d/mysql.list > /dev/null

echo "Updating package list..."
sudo apt update

echo "Installing MySQL Server..."
sudo apt install -y mysql-community-server

echo "Starting MySQL..."
sudo systemctl enable --now mysql

echo
echo "====================================="
echo " MySQL Installed Successfully!"
echo "====================================="
mysql --version

echo
sudo systemctl status mysql --no-pager
