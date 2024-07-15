#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
}

# Check and install git
: <<'COMMENT'
environment: cli
category: mandatory
title: git
COMMENT

if is_installed git; then
    echo "git is already installed."
else
    sudo apt install -y git
fi

echo


# Check and install vim
: <<'COMMENT'
environment: cli
category: mandatory
title: vim
COMMENT

if is_installed vim; then
    echo "git is already installed."
else
    sudo apt install -y vim
fi

echo

# Check and install flatpak
: <<'COMMENT'
environment: cli
category: mandatory
title: flatpak cli
COMMENT

if is_installed flatpak; then
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

if is_installed google-chrome-stable; then
    echo "google-chrome-stable is already installed."
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
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
