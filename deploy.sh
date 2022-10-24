#!/bin/bash

user_dirs() {
    # Make sure user-dirs are created for $USER:
    /usr/bin/xdg-user-dirs-update

    # Make sure user-dirs are created for root:
    /usr/bin/sudo /usr/bin/xdg-user-dirs-update
}

ohmyzsh() {
    # Install ohmyzsh for $USER:
    /usr/bin/sh -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ""

    # Install zsh-autosuggestions for $USER:
    /usr/bin/git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

    # Install zsh-completions for $USER:
    /usr/bin/git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-completions

    # Install ohmyzsh for root:
    /usr/bin/sudo /usr/bin/sh -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ""

    # Install zsh-autosuggestions for root:
    /usr/bin/sudo /usr/bin/git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

    # Install zsh-completions for root:
    /usr/bin/sudo /usr/bin/git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"/plugins/zsh-completions
}

general() {
    # Copy `.zshrc` to $USER's home directory:
    /usr/bin/cp ./etc/skel/.zshrc "$HOME"/

    # Copy `userChrome.css` needed for Tree Style Tab plugin:
    /usr/bin/cp -r ./etc/skel/.mozilla/. "$HOME"/.mozilla/firefox/*.default-esr/

    # Copy `.zshrc` to root's home directory:
    /usr/bin/cp ./etc/skel/.zshrc /root/

    # Update .zshrc's ZSH variable from $USER to root:
    /usr/bin/sudo /usr/bin/sed -i "s|\$HOME|\/root|g" /root/.zshrc
}

yubikey() {
    /usr/bin/pamu2fcfgpamu2fcfg | /usr/bin/sudo /usr/bin/tee -a /etc/u2f_mappings

    /usr/bin/sudo /usr/bin/echo >>/usr/bin/sudo /etc/u2f_mappings

    /usr/bin/sudo /usr/bin/echo 'auth sufficient pam_u2f.so authfile=/etc/u2f_mappings cue' >/etc/pam.d/common-u2f

    for file in $(/usr/bin/sudo /usr/bin/grep -l "@include common-auth" /etc/pam.d/*); do
        if [[ $file == *~ ]]; then
            continue
        
        fi

        if /usr/bin/sudo /usr/bin/grep -q "@include common-u2f" $file; then
            continue
        
        fi

        /usr/bin/sudo /usr/bin/mv $file $file~

        /usr/bin/sudo /usr/bin/awk '/@include common-auth/ {print "@include common-u2f"}; {print}' $file~ >$file
    
    done

    exit
}

user_dirs
ohmyzsh
general
yubikey
