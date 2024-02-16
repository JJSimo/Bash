#!/bin/bash

# This script is designed to install security tools on a Linux system
# It will prompt the user to update and upgrade the system
# Then it will prompt the user to select which security tools to install
# The user can choose to install all the tools or select only those that interest him

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

    # Initialize arrays to track successful and failed installations
    successful_installations=()
    failed_installations=()

    # Function to check if a command is available
    command_exists() {
        command -v "$1" &>/dev/null
    }


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
                echo -e "\n\033[1m[*] Installing nmap \033[0m"
                if apt install nmap -y; then
                    successful_installations+=("nmap")
                else
                    failed_installations+=("nmap")
                fi
                ;;
            2)
                # netdiscover
                echo -e "\n\033[1m[*] Installing netdiscover \033[0m"
                if apt install netdiscover -y; then
                    successful_installations+=("netdiscover")
                else
                    failed_installations+=("netdiscover")
                fi
                ;;
            3)
                # dnsrecon
                echo -e "\n\033[1m[*] Installing dnsrecon \033[0m"
                if apt install dnsrecon -y; then
                    successful_installations+=("dnsrecon")
                else
                    failed_installations+=("dnsrecon")
                fi
                ;;
            4)
                # nikto
                echo -e "\n\033[1m[*] Installing nikto \033[0m"
                if apt install nikto -y; then
                    successful_installations+=("nikto")
                else
                    failed_installations+=("nikto")
                fi
                ;;
            5)
                # dirbuster
                echo -e "\n\033[1m[*] Installing dirbuster \033[0m"
                if apt install dirbuster -y; then
                    successful_installations+=("dirbuster")
                else
                    failed_installations+=("dirbuster")
                fi
                ;;
            6)
                # dirb
                echo -e "\n\033[1m[*] Installing dirb \033[0m"
                if apt install dirb -y; then
                    successful_installations+=("dirb")
                else
                    failed_installations+=("dirb")
                fi
                ;;
            7)
                # ffuf
                echo -e "\n\033[1m[*] Installing ffuf \033[0m"
                if apt install ffuf -y; then
                    successful_installations+=("ffuf")
                else
                    failed_installations+=("ffuf")
                fi
                ;;
            8)
                # smbclient
                echo -e "\n\033[1m[*] Installing smbclient \033[0m"
                if apt install smbclient -y; then
                    successful_installations+=("smbclient")
                else
                    failed_installations+=("smbclient")
                fi
                ;;
            9)
                # BurpSuite
                echo -e "\n\033[1m[*] Installing BurpSuite \033[0m"
                # Define the version and architecture of Burp Suite to download
                version="community" # or "professional" for the paid version
                architecture="linux_64" # for  64-bit systems

                # Download the Burp Suite installer script
                wget https://portswigger.net/burp/communitydownload?requestSource=communityDownloadPage -O burpsuite_${version}_${architecture}.sh

                # Make the installer script executable
                chmod +x burpsuite_${version}_${architecture}.sh

                # Install
                if ./burpsuite_${version}_${architecture}.sh; then
                    successful_installations+=("burpsuite_${version}_${architecture}")
                else
                    failed_installations+=("burpsuite_${version}_${architecture}")
                fi
                ;;
            10)
                # Metasploit
                echo -e "\n\033[1m[*] Installing Prerequisite Packages \033[0m"
                apt install curl postgresql postgresql-contrib
                
                echo -e "\n\033[1m[*] Download metasploit installer script \033[0m"
                curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
                chmod 755 msfinstall

                if ./msfinstall; then
                    successful_installations+=("msfinstall")

                    echo -e "\n\033[1m[*] Start and configure database \033[0m"
                    sudo systemctl start postgresql
                    msfdb init
                else
                    failed_installations+=("msfinstall")     
                fi           
                ;;
            11)
                # netcat
                echo -e "\n\033[1m[*] Installing netcat \033[0m"
                if apt install netcat -y; then
                    successful_installations+=("netcat")
                else
                    failed_installations+=("netcat")
                fi
                ;;
            12)
                # hashcat
                echo -e "\n\033[1m[*] Installing hashcat \033[0m"
                if apt install hashcat -y; then
                    successful_installations+=("hashcat")
                else
                    failed_installations+=("hashcat")
                fi
                ;;
            13)
                # fcrackzip
                echo -e "\n\033[1m[*] Installing fcrackzip \033[0m"
                if apt install fcrackzip -y; then
                    successful_installations+=("fcrackzip")
                else
                    failed_installations+=("fcrackzip")
                fi
                ;;
        esac
    done

    # After all installations have been attempted, print a summary
    echo -e "\n\n\n\033[32mTools installed successfully:\033[0m"
    for tool in "${successful_installations[@]}"; do
        echo -e "\033[32m[*] $tool\033[0m"
    done

    echo -e "\n\033[31mTools not installed due to errors:\033[0m"
    for tool in "${failed_installations[@]}"; do
        echo -e "\033[31m[!] $tool\033[0m"
    done
    echo ""
fi