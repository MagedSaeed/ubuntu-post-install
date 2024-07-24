#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to check if a command is available
command_exists() {
    command -v "$1" &> /dev/null
}

# Check and install git
: <<'COMMENT'
environment: cli
category: mandatory
title: git
COMMENT

if command_exists git; then
    echo "git is already installed."
else
    sudo apt install -y git
fi

echo

# Check and install flatpak
: <<'COMMENT'
environment: cli
category: mandatory
title: flatpak cli
COMMENT

if command_exists flatpak; then
    echo "flatpak is already installed."
else
    sudo apt install -y flatpak
fi

echo

# Check and install flatpak software gui client
: <<'COMMENT'
environment: gui
category: mandatory
title: flatpak software gui client
COMMENT

if is_installed gnome-software-plugin-flatpak; then
    echo "gnome-software-plugin-flatpak is already installed."
else
    sudo apt install -y gnome-software-plugin-flatpak
fi

echo

# Check and install google chrome stable
: <<'COMMENT'
environemnt: gui
category: mandatory
title: google chrome stable
resources: https://gist.github.com/diloabininyeri/637f0353394b95ade468d340f5079ad6
COMMENT

if command_exists google-chrome; then
    echo "google-chrome-stable is already installed."
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
fi

echo

# Check and install visual studio code
: <<'COMMENT'
environemnt: gui
category: mandatory
title: visual studio code
COMMENT

if snap list | grep -q code; then
    echo "Visual Studio Code is already installed."
else
    sudo snap install code --classic
fi

echo

# Check and install virtualenvwrapper
: <<'COMMENT'
environemnt: gui
category: mandatory
title: virtualenvwrapper
COMMENT

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    echo "virtualenvwrapper is already installed."
else
    sudo chmod +x scripts/virtualenvwrapper.sh && bash scripts/virtualenvwrapper.sh
fi

echo

# Check and install zsh
: <<'COMMENT'
environment: cli
category: mandatory
title: zsh
COMMENT

if command_exists zsh; then
    echo "zsh is already installed."
else
    sudo apt install -y zsh
fi

echo

# Check and install oh-my-zsh
: <<'COMMENT'
environemnt: cli
category: mandatory
title: oh-my-zsh
COMMENT

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo

# Check and install p10k theme
: <<'COMMENT'
environemnt: cli
category: mandatory
title: powerlevel10k theme
COMMENT

if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Powerlevel10k theme is already installed."
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc
fi

echo

# Check and install zsh-autosuggestions
: <<'COMMENT'
environment: cli
category: mandatory
title: zsh-autosuggestions
COMMENT

if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed."
else
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    if ! grep -q "zsh-autosuggestions" $HOME/.zshrc; then
        sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' $HOME/.zshrc
    fi
fi

echo

# Check and install redis from the official Redis repository
: <<'COMMENT'
environment: cli
category: mandatory
title: redis
COMMENT

if command_exists redis-server; then
    echo "redis-server is already installed."
else
    curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
    sudo apt-get update
    sudo apt-get install -y redis
fi

echo

# Check and install redis-tools
: <<'COMMENT'
environment: cli
category: mandatory
title: redis-tools
COMMENT

if command_exists redis-cli; then
    echo "redis-tools is already installed."
else
    sudo apt install -y redis-tools
fi

echo

# Install Docker
: <<'COMMENT'
environment: cli
category: mandatory
title: Docker
COMMENT

if command_exists docker; then
    echo "Docker is already installed."
else
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
fi

echo

# Install Docker Compose
: <<'COMMENT'
environment: cli
category: mandatory
title: Docker Compose
COMMENT

if command_exists docker-compose; then
    echo "Docker Compose is already installed."
else
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo

# Install GitHub CLI
: <<'COMMENT'
environment: cli
category: mandatory
title: GitHub CLI
COMMENT

if command_exists gh; then
    echo "GitHub CLI is already installed."
else
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
fi

echo

# Install Java
: <<'COMMENT'
environment: cli
category: mandatory
title: Java
COMMENT

if command_exists java; then
    echo "Java is already installed."
else
    sudo apt update
    sudo apt install -y default-jdk
fi

echo

# Add aliases to ~/.bin/aliasses.sh
mkdir -p $HOME/.bin
cat << 'EOF' > $HOME/.bin/aliasses.sh
alias runserver='python manage.py runserver'
alias makemigrations='python manage.py makemigrations'
alias migrate='python manage.py migrate'
EOF

# Update .bashrc to source ~/.bin/aliasses.sh
if ! grep -q 'source ~/.bin/aliasses.sh' $HOME/.bashrc; then
    echo 'source ~/.bin/aliasses.sh' >> $HOME/.bashrc
fi

# Update .zshrc to source ~/.bin/aliasses.sh
if ! grep -q 'source ~/.bin/aliasses.sh' $HOME/.zshrc; then
    echo 'source ~/.bin/aliasses.sh' >> $HOME/.zshrc
fi

echo "Aliases have been added and configuration files updated."

# Check and install Node.js and npm (latest LTS)
: <<'COMMENT'
environment: cli
category: mandatory
title: Node.js and npm (latest LTS)
COMMENT

if command_exists node && command_exists npm; then
    echo "Node.js and npm are already installed."
else
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

echo

# Check and install gnome-tweaks
: <<'COMMENT'
environment: gui
category: mandatory
title: gnome-tweaks
COMMENT

if command_exists gnome-tweaks; then
    echo "gnome-tweaks is already installed."
else
    sudo apt install -y gnome-tweaks
fi

echo
