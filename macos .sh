#!/bin/bash

set -e

echo "Installing Homebrew..."

if ! command -v brew &>/dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Updating Homebrew..."

brew update

echo "Installing MySQL..."

brew install mysql

echo "Starting MySQL..."

brew services start mysql

mysql --version

echo

brew services list | grep mysql

echo

echo "Installation Completed Successfully."
