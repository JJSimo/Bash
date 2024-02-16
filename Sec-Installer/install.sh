#!/bin/bash

# Function to check if a package is installed
function is_installed() {
    dpkg -s "$1" &>/dev/null
}

# Function to check if a command is available
function command_exists() {
    command -v "$1" &>/dev/null
}


if [[ $EUID -ne  0 ]]; then
    echo "[!] This script must be run as root"  
    exit  1
else
    # Prompt the user to decide if they want to update and upgrade
    echo -e "Do you want to update and upgrade? (Y/n)"
    read -r update_choice

    # If the user responds with 'Y' or 'y', perform the update and upgrade
    if [[ $update_choice =~ ^([yY])$ ]]; then
        echo "[*] Updating and Upgrading"
        apt-get update && sudo apt-get upgrade -y
    fi


    sudo apt-get install dialog
    cmd=(dialog --separate-output --checklist "[*] Please Select Software you want to install:"  22  76  16)
    options=(0 "Install All" off
             1 "nmap" off
             2 "netdiscover" off
             3 "dnsrecon" off
             4 "nikto" off
             5 "dirbuster" off
             6 "dirb" off
             7 "ffuf" off
             8 "smbclient" off
             9 "BurpSuite" off
             10 "Metasploit" off
             11 "netcat" off
             12 "hashcat" off
             13 "fcrackzip" off)
    choices=$("${cmd[@]}" "${options[@]}"  2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
        # If the "Install All" option is selected, set all options to be installed
        if [ "$choice" == "0" ]; then
            for option in "${options[@]}"
            do
                # Extract the option number and set it to be installed
                option_number=$(echo $option | cut -d' ' -f1)
                if [ "$option_number" -ne "0" ]; then
                    choices+=" $option_number"
                fi
            done
            # Continue with the loop to process the rest of the choices
            continue
        fi

        # Code to process other choices
        case $choice in
            1)
                # nmap
                echo -e "[*] Installing nmap \n"
                apt install nmap -y
                ;;
            2)
                # netdiscover
                echo -e "[*] Installing netdiscover \n"
                apt install netdiscover -y
                ;;
            3)
                # dnsrecon
                echo -e "[*] Installing dnsrecon \n"
                apt install -y dnsrecon
                ;;
            4)
                # nikto
                echo -e "[*] Installing nikto \n"
                apt install -y nikto
                ;;
            5)
                # dirbuster
                echo -e "[*] Installing dirbuster \n"
                if ! apt install -y dirbuster; then
                    echo "Error installing dirbuster"
                fi
                apt install dirbuster -y
                ;;
            6)
                # dirb
                echo -e "[*] Installing dirb \n"
                apt install dirb -y
                ;;
            7)
                # ffuf
                echo -e "[*] Installing ffuf \n"
                apt install ffuf -y
                ;;
            8)
                # smbclient
                echo -e "[*] Installing smbclient \n"
                apt install smbclient -y
                ;;
            9)
                # BurpSuite
                echo -e "[*] Installing BurpSuite \n"
                # Define the version and architecture of Burp Suite to download
                version="community" # or "professional" for the paid version
                architecture="linux_64" # for  64-bit systems

                # Download the Burp Suite installer script
                wget https://portswigger.net/burp/communitydownload?requestSource=communityDownloadPage -O burpsuite_${version}_${architecture}.sh

                # Make the installer script executable
                chmod +x burpsuite_${version}_${architecture}.sh

                # Run the installer script
                sudo ./burpsuite_${version}_${architecture}.sh
                ;;
            10)
                # Metasploit
                echo -e "[*] Installing Prerequisite Packages \n"
                apt install curl postgresql postgresql-contrib
                
                echo -e "[*] Download metasploit installer script \n"
                curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
                chmod 755 msfinstall
                sudo ./msfinstall

                echo -e "[*] Start and configure database \n"
                sudo systemctl start postgresql
                msfdb init
                ;;
            11)
                # netcat
                echo -e "[*] Installing netcat \n"
                apt install netcat -y
                ;;
            12)
                # hashcat
                echo -e "[*] Installing hashcat \n"
                apt install hashcat -y
                ;;
            13)
                # fcrackzip
                echo -e "[*] Installing fcrackzip \n"
                apt install fcrackzip -y
                ;;
        esac
    done
fi