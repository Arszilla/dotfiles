#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "The script needs root permissions to run. Please ensure that you're running the script with 'sudo'."
    exit
fi

while :
do
    echo "Specify your device:"
    echo "1) Laptop"
    echo "2) Desktop"
    
    read -p "Enter a number between 1 and 2: " DEVICE
    
    if [[ "$DEVICE" -eq 1 || "$DEVICE" -eq 2 ]]
    then
        if [ "$DEVICE" -eq 1 ]
        then
            # Move the laptop specific files to /home/$SUDO_USER/:
            /usr/bin/cp -r ./"Laptop Specific"/etc/skel/. /home/$SUDO_USER/
            
        elif [ "$DEVICE" -eq 2 ]
        then
            # Move the laptop specific files to /home/$SUDO_USER/:
            /usr/bin/cp -r ./"Desktop Specific"/etc/skel/. /home/$SUDO_USER/
            
        fi

        break
        
    else
        echo "Please input either 1 or 2 as an input."
        echo
    
    fi
done

# Dependencies
/usr/bin/sudo apt install xsel xclip -y

# oh-my-zsh related actions:
/usr/bin/sudo -H -u $SUDO_USER sh -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# oh-my-zsh autosuggestions plugin installation:
/usr/bin/sudo -H -u $SUDO_USER /usr/bin/git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/$SUDO_USER/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# oh-my-zsh completions plugin installation:
/usr/bin/sudo -H -u $SUDO_USER /usr/bin/git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-/home/$SUDO_USER/.oh-my-zsh/custom}/plugins/zsh-completions

# Add the dotfiles to the /home/$SUDO_USER/:
/usr/bin/cp -r ./etc/skel/. /home/$SUDO_USER/

# Replace SSH's config at /etc/ssh/:
/usr/bin/cp -r ./etc/ssh/ssh_config /etc/ssh/

# Set the permissions for the SSH private and public keys:
for FILE in /home/$SUDO_USER/.ssh/*
do

    # Check if $FILE is README.md:
    if [ "$FILE" == "README.md" ]
    then
        /usr/bin/rm $FILE
    
    # Check if $FILE is known_hosts:
    elif [ "$FILE" == "known_hosts" ]
    then
        continue

    # Check if $FILE is a public key:
    elif [ "${FILE: -4}" == ".pub" ]
    then
        /usr/bin/chmod 644 $FILE

    # If $FILE is a private key:
    else
        /usr/bin/chmod 600 $FILE

    fi
done
