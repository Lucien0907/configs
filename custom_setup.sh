#!/bin/bash

# For ghostty
sed -i '1i export TERM=xterm-256color' ~/.bashrc
source ~/.bashrc 

sudo apt update && sudo apt upgrade -y

# Generate ssh key pair
ssh-keygen -t rsa -C tao-wei_chan -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub
read -p "Copy and add the public key to github and ado, then Enter to continue..."

# Set up git
git config --global user.name "Tao-Wei Chan"
git config --global user.email "taowei.c@outlook.com"

# Set up tmux
mkdir -p ~/dev
git clone git@github.com:Lucien0907/configs.git ~/dev/configs
cp ~/dev/configs/.tmux.conf ~/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
~/.tmux/plugins/tpm/bin/install_plugins

# Install yazi
sudo apt update && sudo apt instsall -y unzip
git clone git@github.com:Lucien0907/yazi-config.git ~/.config/yazi
curl -L -o yazi.zip https://github.com/sxyazi/yazi/releases/download/v25.3.2/yazi-x86_64-unknown-linux-gnu.zip
unzip -q yazi.zip && rm yazi.zip
sudo rm -rf /opt/yazi && sudo mv yazi-x86_64-unknown-linux-gnu /opt/yazi
echo 'export PATH="/opt/yazi:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Install pyenv
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl -fsSL https://pyenv.run | bash -s -- -y
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init - bash)"' >> ~/.profile
source ~/.bashrc
pyenv install 3.10.16
pyenv global 3.10.16
pyenv versions

# Install pipx and poetry
sudo apt update && sudo apt upgrade -y
sudo apt install -y pipx
pipx ensurepath
pipx install poetry
pipx inject poetry poetry-plugin-shell
source ~/.bashrc

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
sudo apt install -y imagemagick libmagickwand-dev
git clone -b linux https://github.com/Lucien0907/nvim.git ~/.config/nvim
sudo apt install -y luarocks fzf
rm -f nvim-linux-x86_64.tar.gz

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
lazygit --version
rm -f lazygit.tar.gz
rm -rf lazygit

# install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
lazydocker --version

# install docker 
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the Docker packages.
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
