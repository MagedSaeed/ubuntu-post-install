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
