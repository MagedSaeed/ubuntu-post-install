:'
environment: cli
category: mandatory
title: flatpak cli
'
sudo apt install -y flatpak

:'
environment: gui
category: mandatory
title: flatpak software gui client
'
sudo apt install -y gnome-software-plugin-flatpak

:'
environemnt: gui
category: mandatory
title: google chrome stable
resources: https://gist.github.com/diloabininyeri/637f0353394b95ade468d340f5079ad6
'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
