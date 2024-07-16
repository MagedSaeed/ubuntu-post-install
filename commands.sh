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
