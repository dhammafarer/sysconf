#!/bin/bash

# enable sources:
sudo sed 's/# deb/deb/' -i /etc/apt/sources.list

# add PPAs:
sudo add-apt-repository -y ppa:pi-rho/dev
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo add-apt-repository -y ppa:diodon-team/stable
sudo add-apt-repository -y ppa:numix/ppa
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

# PPA for google-chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# PPA for nodejs
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

# PPA for purple-facebook
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_$(lsb_release -rs)/ /' >> /etc/apt/sources.list.d/jgeboski.list"
cd /tmp && wget  http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_$(lsb_release -rs)/Release.key
sudo apt-key add - < Release.key

# add i386 architecture
sudo dpkg --add-architecture i386

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# install apps
sudo apt-get -y install $(cat list/development.list list/favorites.list list/utilities.list)

# Virtualbox
sudo adduser pawel vboxusers

# Vagrant
cd /tmp
wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
sudo dpkg -i vagrant_*

# Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo chmod 755 /usr/local/bin/composer

# ZSH
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`

# Janus
curl -L https://bit.ly/janus-bootstrap | bash

# Powerline with fontconfig
pip install --user git+git://github.com/Lokaltog/powerline

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# xkb configuration
cd /usr/share/X11/xkb
sudo mv rules/evdev.xml rules/evdev.xml.backup
sudo cp /home/pawel/sysconf/sys/xkb/rules/evdev.xml rules/evdev.xml
sudo cp /home/pawel/sysconf/sys/xkb/symbols/pw symbols/
sudo rm -rf /var/lib/xkb/*

# Homestead
cd ~
git clone https://github.com/laravel/homestead.git Homestead
cd ~/Homestead
bash init.sh
mkdir ~/Code
composer global require "laravel/installer"

# download Pidgin emoticons
cd /tmp
wget https://github.com/Hernou/pidgin-EAP/archive/master.tar.gz
tar -xvf master.tar.gz
cp -rf pidgin-EAP-master/{.fonts,.purple} ~

# setup dotfiles
files="zshrc vimrc.after vimrc.before tmux.conf aliases janus"
mkdir /home/pawel/sysconf-old
for file in $files; do
    mv /home/pawel/.$file /home/pawel/sysconf-old
    ln -s /home/pawel/sysconf/$file /home/pawel/.$file
done

# disable shopping suggestions
gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

# enable recursive search
gsettings set org.gnome.nautilus.preferences enable-interactive-search false

# Ubuntu restricted extras:
sudo apt-get install -y ubuntu-restricted-extras

# prompt for a reboot
clear
echo ""
echo "===================="
echo " TIME FOR A REBOOT! "
echo "===================="
echo ""
