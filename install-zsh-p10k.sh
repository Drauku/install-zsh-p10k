#!/bin/bash
## a script to install zsh, oh-my-zsh, powerlevel10k, meslo lgs fonts, zsh plugins

## download and run this script with this command: sh -c "$(curl -fsSL https://raw.github.com/drauku/install-zsh-p10k/master/install-zsh-p10k.sh)"

# user warning to exit initial zsh shell to continue this script
echo "ONCE 'oh-my-zsh' IS FINISHED INSTALLING, TYPE 'exit' TO CONTINUE THIS SCRIPT"
sleep 5

## install required apps
apt update -y && apt upgrade -y && apt install -y curl fontconfig git zsh

## download and install necessary fonts
mkdir -p ~/.fonts && cd ~/.fonts || return
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v

## install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

## download zsh-z zsh-autosuggestions zsh-syntax-highlighting plugin
git clone https://github.com/agkozak/zsh-z "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

## download powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"

## backup original .zshrc and set theme, plugins, and auto load the .p10k.zsh on terminal session start
[[ ! -f ~/.zshrc.original ]] && cp ~/.zshrc ~/.zshrc.original
sed -zi 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc
sed -zi 's|plugins=(git)|plugins=(git zsh-z zsh-autosuggestions zsh-syntax-highlighting)|g' ~/.zshrc
sed -i '1i \ source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"; fi\n' ~/.zshrc
sed -i '1i if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then' ~/.zshrc
sed -i '1i # confirmations, etc.) must go above this block; everything else may go below.' ~/.zshrc
sed -i '1i # Initialization code that may require console input (password prompts, [y/n]' ~/.zshrc
sed -i '1i # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.' ~/.zshrc
{
  printf "\nPOWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true\n";
  printf "\n# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh.\n";
  printf "\n[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
} >> ~/.zshrc

## backup original .p10k.conf and replace with drauku's custom .p10k.conf
curl -fs https://raw.githubusercontent.com/Drauku/install-zsh-p10k/main/.p10k.zsh.custom -o ~/.p10k.zsh.custom
[[ ! -f ~/.p10k.zsh.original ]] && cp ~/.p10k.zsh ~/.p10k.zsh.original
cp --backup ~/.p10k.zsh.custom ~/.p10k.zsh

## exit the current shell, forcing a re-log in to activate the new custom shell format
exit
