#!/bin/bash
# Fail on any command.
set -euxo pipefail

# Ensure all required packages are installed
sudo dnf install -y python3 python3-pip powerline-fonts fontconfig

# Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Powerline
pip install --upgrade pip setuptools
pip install powerline-status

# Copy the VIM configuration file
cp configs/.vimrc ~/.vimrc

# Install Powerline fonts
mkdir -p ~/.fonts
cp -a fonts/. ~/.fonts/
fc-cache -vf ~/.fonts/

# Deactivate the virtual environment
deactivate
echo "done"
