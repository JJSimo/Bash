#!/bin/bash

# Prompt the user to decide if they want to update and upgrade
echo -e "Do you want to update and upgrade? (Y/n)"
read -r update_choice
 
# If the user responds with 'Y' or 'y', perform the update and upgrade
if [[ $update_choice =~ ^([yY])$ ]]; then
    echo "[*] Updating and Upgrading"
    sudo apt-get update && sudo apt-get upgrade -y
fi

# Initialize arrays to track successful and failed installations
successful_installations=()
failed_installations=()

echo -e "\n\033[1m[*] Installing wget \033[0m"
if sudo apt install wget -y; then
    successful_installations+=("wget")
else
    failed_installations+=("wget")
fi

echo -e "\n\033[1m[*] Installing git \033[0m"
if sudo apt install git -y; then
    successful_installations+=("git")
else
    failed_installations+=("git")
fi

echo -e "\n\033[1m[*] Installing Java \033[0m"
if sudo apt install default-jre -y; then
    successful_installations+=("Java jre")

    if sudo apt install default-jdk -y; then
        successful_installations+=("Java jdk")
    else
        failed_installations+=("Java jdk")
    fi
else
    failed_installations+=("Java jre")
fi

echo -e "\n\033[1m[*] Installing Python \033[0m"
if sudo apt install python3 -y; then
    successful_installations+=("Python")
else
    failed_installations+=("Python")
fi

echo -e "\n\033[1m[*] Installing Wireshark \033[0m"
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt update
if sudo apt install wireshark -y; then
    successful_installations+=("Wireshark")
else
    failed_installations+=("Wireshark")
fi

echo -e "\n\033[1m[*] Installing nmap \033[0m"
if sudo apt install nmap -y; then
    successful_installations+=("nmap")
else
    failed_installations+=("nmap")
fi

echo -e "\n\033[1m[*] Installing Flameshot \033[0m"
if sudo apt install flameshot -y; then
    successful_installations+=("Flameshot")
else
    failed_installations+=("Flameshot")
fi

echo -e "\n\033[1m[*] Installing gnome-shell-extensions \033[0m"
if sudo apt install gnome-shell-extensions -y; then
    successful_installations+=("gnome-shell-extensions")
else
    failed_installations+=("gnome-shell-extensions")
fi

echo -e "\n\033[1m[*] Installing gnome-shell-extension-manager \033[0m"
if sudo apt install gnome-shell-extension-manager -y; then
    successful_installations+=("gnome-shell-extension-manager")
else
    failed_installations+=("gnome-shell-extension-manager")
fi


echo -e "\n\033[1m[*] Installing gnome-tweaks \033[0m"
sudo add-apt-repository universe
if sudo apt install gnome-tweaks -y; then
    successful_installations+=("gnome-tweaks")
else
    failed_installations+=("gnome-tweaks")
fi

# Extensions:
# - https://extensions.gnome.org/
# - Blur My Shell
# - X11 Gestures (enables swipe desktops with 3 fingers)
# - 

# X11 Gestures
echo -e "\n\033[1m[*] Installing touchegg (for X11 Gestures) \033[0m"
sudo add-apt-repository ppa:touchegg/stable
if sudo apt install touchegg -y; then
    successful_installations+=("touchegg (for X11 Gestures)")
else
    failed_installations+=("touchegg (for X11 Gestures)")
fi


#echo -e "\n\033[1m[*] Installing Google Chrome \033[0m"
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#if sudo dpkg -i google-chrome-stable_current_amd64.deb; then
    #successful_installations+=("Google Chrome")
#else
    #failed_installations+=("Google Chrome")
#fi


# NVIDIA Drivers
# sudo apt install nvidia-driver-535 nvidia-dkms-535

# Obsidian
# https://obsidian.md/download
# download deb
# sudo dpkg -i .deb
# Options > Community Plugin > Enable Community Plugin > Browse > Git > Install it and Enable it
# CTRL+P > git clone a new repo 
# look url in Bitwarden > Obsidian_Notes > enter


echo -e "\n\n\n\033[32mTools installed successfully:\033[0m"
for tool in "${successful_installations[@]}"; do
    echo -e "\033[32m[*] $tool\033[0m"
done

echo -e "\n\033[31mTools not installed due to errors:\033[0m"
for tool in "${failed_installations[@]}"; do
    echo -e "\033[31m[!] $tool\033[0m"
done 

