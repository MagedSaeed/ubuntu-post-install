#!/bin/bash

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Installing Python3..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-full python3-setuptools python3-venv
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "pip3 is not installed. Installing pip3..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
fi

# Install virtualenvwrapper
echo "Installing virtualenvwrapper..."
sudo pip3 install virtualenvwrapper --break-system-packages

# Get the path to Python3 binary
PYTHON3_BIN_PATH=/usr/local/bin/virtualenvwrapper.sh

# Add virtualenvwrapper settings to .bashrc
echo "Adding virtualenvwrapper settings to .bashrc..."
{
    echo ""
    echo "# Virtualenvwrapper settings"
    echo "export WORKON_HOME=$HOME/.virtualenvs"
    echo "export VIRTUALENVWRAPPER_PYTHON=$(which python3)"
    echo "source $PYTHON3_BIN_PATH/virtualenvwrapper.sh"
} >> ~/.bashrc

# Reload .bashrc
echo "Reloading .bashrc..."
source ~/.bashrc

echo "virtualenvwrapper installation and setup complete."
