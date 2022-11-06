#!/bin/bash
## Install script for zsh, oh-my-zsh, powerlevel10k, zsh plugins, and a custom .p10k.zsh config file

## Install zsh
apt install -y zsh git curl fontconfig

## Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Download and install necessary fonts
mkdir -p ~/.fonts && cd ~/.fonts
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

## Install fonts
command fc-cache
fc-cache -f -v

## Download powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

## Download zsh-z zsh-autosuggestions zsh-syntax-highlighting plugin
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## Set theme and plugins
sed -zi 's:ZSH_THEME="robbyrussel":ZSH_THEME="powerlevel10k/powerlevel10k:g"' ~/.zshrc
sed -zi 's:plugins=(git):plugins=(git zsh-z zsh-autosuggestions zsh-syntax-highlighting):g' ~/.zshrc

## Backup original .p10k.conf and replace with Drauku's custom .p10k.conf
cp ~/.p10k.conf ~/.p10k.conf.original
wget https://gist.githubusercontent.com/Drauku/install-zsh-p10k/main/.p10k.zsh.custom
cp ~/.p10k.custom ~/.p10k.conf

## Installation finish notification and instructions
echo " ZSH, OH-MY-ZSH, POWERLEVEL10k, P10k addons, and Drauku's custom .p10k.zsh have been installed."
echo " Restart the terminal session to see all changes."
