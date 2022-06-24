#!/bin/bash

help_menu() {
    echo "Usage: $0 [-d/-l] [-h]" >&2
}

user_dirs() {
    # Make sure user-dirs are created for $USER:
    /usr/bin/xdg-user-dirs-update

    # Make sure user-dirs are created for root:
    /usr/bin/sudo /usr/bin/xdg-user-dirs-update
}

desktop() {
    # Copy desktop specific dotfiles to $USER's home directory:
    /usr/bin/cp -r "$1"/Desktop/etc/skel/. "$HOME"/
    /usr/bin/cp -r "$1"/etc/skel/Pictures/ "$HOME"/

    # Copy desktop specific dotfiles to root's home directory:
    /usr/bin/sudo /usr/bin/cp -r "$1"/Desktop/etc/skel/. /root/
    /usr/bin/sudo /usr/bin/cp -r "$1"/etc/skel/Pictures/ /root/
}

laptop() {
    # Copy desktop specific dotfiles to $USER's home directory:
    /usr/bin/cp -r "$1"/Laptop/etc/skel/. "$HOME"/
    /usr/bin/mkdir -p "$HOME"/Pictures/Wallpapers && /usr/bin/cp "$1"/etc/skel/Pictures/Wallpapers/vertical.png "$_"

    # Copy desktop specific dotfiles to root's home directory:
    /usr/bin/sudo /usr/bin/cp -r "$1"/Laptop/etc/skel/. /root/
    /usr/bin/sudo /usr/bin/mkdir -p /root/Pictures/Wallpapers && /usr/bin/sudo /usr/bin/cp "$1"/etc/skel/Pictures/Wallpapers/vertical.png "$_"
}

ohmyzsh() {
    # Install ohmyzsh for $USER:
    /usr/bin/sh -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Install zsh-autosuggestions for $USER:
    /usr/bin/git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

    # Install zsh-completions for $USER:
    /usr/bin/git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-completions

    # Install ohmyzsh for root:
    /usr/bin/sudo /usr/bin/sh -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Install zsh-autosuggestions for root:
    /usr/bin/sudo /usr/bin/git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

    # Install zsh-completions for root:
    /usr/bin/sudo /usr/bin/git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"/plugins/zsh-completions
}

general() {
    # Copy general dotfiles (excluding .mozilla/) to $USER's home directory:
    /usr/bin/rsync -az --exclude .mozilla --exclude Pictures/ "$1"/etc/skel/ "$HOME"/

    # Copy `userChrome.css` needed for Tree Style Tab plugin:
    /usr/bin/cp -r "$1"/etc/skel/.mozilla/. "$HOME"/.mozilla/firefox/*.default-esr/

    # Copy general dotfiles (excluding .mozilla/) to root's home directory:
    /usr/bin/sudo /usr/bin/rsync -az --exclude .mozilla --exclude Pictures/ "$1"/etc/skel/ /root/

    # Copy ssh_config to /etc/ssh/:
    /usr/bin/sudo /usr/bin/cp "$1"/etc/ssh/ssh_config /etc/ssh/
}

main() {
    # We're going to need root rights at some point:
    if [ "$(whoami)" != "root" ]; then
        /usr/bin/sudo -v
    fi

    # Check if any flags are given, if not display the help menu
    if (($# != 1)); then
        help_menu
        exit 1
    fi

    # Get CWD i.e. where the script is located:
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/" && pwd)"

    while getopts ":dlh" option; do
        case $option in
        d) # Desktop
            user_dirs
            desktop "$script_dir"
            general "$script_dir"
            ;;
        l) # Laptop
            user_dirs
            laptop "$script_dir"
            general "$script_dir"
            ;;
        h | \? | *) # Display help
            help_menu
            exit 1
            ;;
        esac
    done
}

main "$@"
