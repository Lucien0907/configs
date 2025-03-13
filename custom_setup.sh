#!/bin/bash

# Default values
EMAIL=""
PROTOCOL="https" # Default to HTTPS protocal

# Parse named arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
  --git-user-email)
    EMAIL="$2"
    shift 2
    ;;
  --git-protocol)
    PROTOCOL="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    echo "Usage: $0 --git-user-email your-email@example.com [--git-protocol ssh|https]"
    exit 1
    ;;
  esac
done

# Ensure required arguments are provided
if [ -z "$EMAIL" ]; then
  echo "Error: --git-user-email is required."
  echo "Usage: $0 --git-user-email your-email@example.com [--git-protocol ssh|https]"
  exit 1
fi

# Set Git remote URL format
GITHUB_USER_NAME="Lucien0907"
if [ "$PROTOCOL" == "ssh" ]; then
  GITHUB_BASE_URL="git@github.com:$GITHUB_USER_NAME"
elif [ "$PROTOCOL" == "https" ]; then
  GITHUB_BASE_URL="https://github.com/$GITHUB_USER_NAME"
else
  echo "Error: Invalid protocol. Use 'ssh' or 'https'."
  exit 1
fi

echo $PROTOCOL
echo $EMAIL

# For ghostty
echo '############################## setting TERM for ghostty ##############################'
if ! grep -q "1i export TERM=xterm-256color" ~/.bashrc; then
  sed -i '1i export TERM=xterm-256color' ~/.bashrc
  source ~/.bashrc
fi

# Generate ssh key pair
echo '############################## generate ssh key pair ##############################'
ssh-keygen -t rsa -C tao-wei_chan -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub
read -p "Copy and add the public key to github and ado, then Enter to continue..."

# Set up git
echo '############################## set up git user name & email ##############################'
git config --global user.name "Tao-Wei Chan"
git config --global user.email $EMAIL

echo '############################## updrade apt packages ##############################'
sudo apt update && sudo apt upgrade -y

echo '############################## install ubuntu-drivers-common ##############################'
sudo apt install ubuntu-drivers-common

# Install nvidia driver
echo '############################## Install Nvidia Driver ##############################'

# Set up tmux
echo '############################## set up tmux ##############################'
read -p "tmux?"
mkdir -p ~/dev
git clone $GITHUB_BASE_URL/configs.git ~/dev/configs
cp ~/dev/configs/.tmux.conf ~/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
~/.tmux/plugins/tpm/bin/install_plugins

# Install yazi
echo '############################## install yazi ##############################'
read -p "yazi?"
sudo apt update && sudo apt install -y unzip
if ! grep -q 'export PATH="/opt/yazi:$PATH"' ~/.bashrc; then
  echo 'export PATH="/opt/yazi:$PATH"' >>~/.bashrc
  source ~/.bashrc
fi
YAZI_FUNC='
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
'
if ! grep -q "function y() {" ~/.bashrc; then
  echo "$YAZI_FUNC" >>~/.bashrc
fi
sudo rm -rf /opt/yazi
git clone $GITHUB_BASE_URL/yazi-config.git ~/.config/yazi
curl -L -o yazi.zip https://github.com/sxyazi/yazi/releases/download/v25.3.2/yazi-x86_64-unknown-linux-gnu.zip
unzip -q yazi.zip
sudo mv yazi-x86_64-unknown-linux-gnu /opt/yazi
rm yazi.zip

# Install pyenv
echo '############################## install pyenv ##############################'
read -p "pyenv?"
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl git \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl -fsSL https://pyenv.run | bash -s -- -y
# for line in \
#   'export PYENV_ROOT="$HOME/.pyenv"' \
#   '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' \
#   'eval "$(pyenv init - bash)"'; do
#   grep -qxF "$line" ~/.bashrc || echo "$line" >>~/.bashrc
#   grep -qxF "$line" ~/.profile || echo "$line" >>~/.profile
# done
echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bashrc
echo 'eval "$(pyenv init - bash)"' >>~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.profile
echo 'eval "$(pyenv init - bash)"' >>~/.profile
source ~/.bashrc
source ~/.profile
pyenv install 3.10.16
pyenv global 3.10.16
pyenv versions

# Install pipx
echo '############################## install pipx ##############################'
read -p "pipx?"
sudo apt update && sudo apt upgrade -y
sudo apt install -y pipx
pipx ensurepath

# Install poetry
echo '############################## install poetry ##############################'
read -p "poetry?"
pipx install poetry
pipx inject poetry poetry-plugin-shell
source ~/.bashrc

# Install neovim
echo '############################## install neovim ##############################'
read -p "neovim?"
if ! grep -q 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >>~/.bashrc
fi
sudo apt update && sudo apt install -y fd-find ripgrep luarocks fzf imagemagick libmagickwand-dev luarocks fzf
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
source ~/.bashrc
git clone -b ubuntu $GITHUB_BASE_URL/nvim.git ~/.config/nvim
rm -f nvim-linux-x86_64.tar.gz

echo '############################## set up pynvim venv ##############################'
read -p "pynvim?"
NVIM_OPTION_FILE="$HOME/.config/nvim/lua/config/options.lua"
pyenv virtualenv 3.10.16 pynvim
PYENV_VERSION=pynvim pyenv exec pip install --upgrade pip
PYENV_VERSION=pynvim pyenv exec pip install pynvim
PYENV_VERSION=pynvim pyenv exec pip install debugpy
if [ -f $NVIM_OPTION_FILE ]; then
  echo "Update neovim python provider in $NVIM_OPTION_FILE "
  if grep -q 'vim.g.python3_host_prog =' "$NVIM_OPTION_FILE"; then
    sed -i "s|vim.g.python3_host_prog = \".*\"|vim.g.python3_host_prog = \"$(pyenv prefix pynvim)/bin/python\"|" ~/.config/nvim/lua/config/options.lua
  else
    echo "" >>"$NVIM_OPTION_FILE"
    echo "vim.g.python3_host_prog = \"$(pyenv prefix pynvim)/bin/python\"" >>"$NVIM_OPTION_FILE"
  fi
else
  echo "File $NVIM_OPTION_FILE does not exist"
fi

# Download and install nvm
echo '############################## install nvm ##############################'
read -p "nvm?"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
node -v
nvm current
npm -v
npm install -g neovim

# install lazygit
echo '############################## install lazygit ##############################'
read -p "lazygit?"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
lazygit --version
rm -f lazygit.tar.gz
rm -rf lazygit

# install lazydocker
echo '############################## install lazydocker ##############################'
read -p "lazydocker?"
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
lazydocker --version

# install nvidia container-toolkit
echo '############################## install docker ##############################'
read -p "nvidia-container-toolkit?"
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# install docker
echo '############################## install docker ##############################'
read -p "docker?"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
   $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update

# Install the Docker packages.
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
