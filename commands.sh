#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
}

# Check and install git
:'
environment: cli
category: mandatory
title: git
'
if is_installed git; then
    echo "git is already installed."
else
    sudo apt install -y git
fi

# Check and install vim
:'
environment: cli
category: mandatory
title: vim
'
if is_installed vim; then
    echo "vim is already installed."
else
    sudo apt install -y vim
fi

# Check and install flatpak
:'
environment: cli
category: mandatory
title: flatpak cli
'
if is_installed flatpak; then
    echo "flatpak is already installed."
else
    sudo apt install -y flatpak
fi

# Check and install flatpak software gui client
:'
environment: gui
category: mandatory
title: flatpak software gui client
'
if is_installed gnome-software-plugin-flatpak; then
    echo "gnome-software-plugin-flatpak is already installed."
else
    sudo apt install -y gnome-software-plugin-flatpak
fi

# Check and install google chrome stable
:'
environemnt: gui
category: mandatory
title: google chrome stable
resources: https://gist.github.com/diloabininyeri/637f0353394b95ade468d340f5079ad6
'
if is_installed google-chrome-stable; then
    echo "google-chrome-stable is already installed."
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
fi

# Check and install visual studio code
:'
environemnt: gui
category: mandatory
title: visual studio code
'
if snap list | grep -q code; then
    echo "Visual Studio Code is already installed."
else
    sudo snap install code --classic
fi

# Check and install virtualenvwrapper
:'
environemnt: cli
category: mandatory
title: virtualenvwrapper
'
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    echo "virtualenvwrapper is already installed."
else
    sudo chmod +x scripts/virtualenvwrapper.sh && bash scripts/virtualenvwrapper.sh
fi
