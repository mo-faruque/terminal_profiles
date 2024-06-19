# Fail on any command.
set -eux pipefail

# Install Powerline for VIM.
sudo dnf install -y python3-pip
python3 -m venv venv
source venv/bin/activate
pip install powerline-status
sudo cp configs/.vimrc ~/.vimrc
#sudo zypper install -y fonts-powerline
sudo dnf install -y powerline-fonts

# Install Patched Font
mkdir ~/.fonts
sudo cp -a fonts/. ~/.fonts/
fc-cache -vf ~/.fonts/
