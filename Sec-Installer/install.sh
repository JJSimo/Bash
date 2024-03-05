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
    #!/bin/bash
    onoff=off
    cmd=(dialog --output-fd 1 --separate-output --extra-button --extra-label "Select All" --cancel-label "Select None" --checklist "Select options:" 0 0 0)
    load-dialog () {
        options=(
                    1 "nmap" $onoff
                    2 "netdiscover" $onoff
                    3 "dnsrecon" $onoff
                    4 "nikto" $onoff
                    5 "dirbuster" $onoff
                    6 "dirb" $onoff
                    7 "ffuf" $onoff
                    8 "smbclient" $onoff
                    9 "BurpSuite" $onoff
                    10 "Metasploit" $onoff
                    11 "netcat" $onoff
                    12 "hashcat" $onoff
                    13 "fcrackzip" $onoff
                    14 "responder" $onoff
                    15 "ntlmrelayx.py (impacket)" $onoff
                    16 "mitm6" $onoff
                    17 "ldapdomaindump" $onoff
                    18 "neo4j" $onoff
                    19 "bloodhound" $onoff
                    20 "plumhound" $onoff
                    21 "crackmapexec" $onoff
                    22 "proxychains" $onoff
                    23 "sshuttle" $onoff
        )
        choices=$("${cmd[@]}" "${options[@]}")
    }
    load-dialog
    exit_code="$?"
    
    while [[ $exit_code -ne 0 ]]; do
    case $exit_code in
        1) clear; onoff=off; load-dialog;;
        3) clear; onoff=on; load-dialog;;
    esac
    exit_code="$?"
    done
    
    clear
    for choice in $choices
    do
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
                architecture="linux" # for  64-bit systems
                v="v2023_12_1_5" 
                
                cd /opt/
                # Download the Burp Suite installer script
                wget -S https://portswigger.net/burp/communitydownload?requestSource=communityDownloadPage -O burpsuite_${version}_${architecture}_${v}.sh
                # Make the installer script executable
                chmod +x /home/simone/Downloads/Downloads/burpsuite_${version}_${architecture}_${v}.sh

                # Install
                if ./burpsuite_${version}_${architecture}_${v}.sh; then
                    successful_installations+=("BurpSuite")
                else
                    failed_installations+=("BurpSuite")
                fi
                ;;
            10)
                # Metasploit
                echo -e "\n\033[1m[*] Installing Prerequisite Packages \033[0m"
                apt install curl postgresql postgresql-contrib -y
                
                echo -e "\n\033[1m[*] Download metasploit installer script \033[0m"
                cd /opt/
                curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
                chmod 755 msfinstall

                if ./msfinstall; then
                    successful_installations+=("metasploit")

                    echo -e "\n\033[1m[*] Start and configure database \033[0m"
                    sudo systemctl start postgresql
                    msfdb init
                else
                    failed_installations+=("metasploit")     
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
            14)
                # responder
                echo -e "\n\033[1m[*] Installing responder \033[0m"
                cd /opt/
                git clone https://github.com/lgandx/Responder
                cd Responder

                if python3 -m pip install -r requirements.txt; then
                    successful_installations+=("responder")
                else
                    failed_installations+=("responder")
                fi
                cd ../
                ;;
            15)
                # ntlmrelayx
                echo -e "\n\033[1m[*] Installing dependencies \033[0m"
                pip install ldap3 dnspython
                pip install ldapdomaindump

                echo -e "\n\033[1m[*] Installing ntlmrelayx.py \033[0m"
                cd /opt/
                git clone https://github.com/CoreSecurity/impacket.git
                cd impacket

                if python3 setup.py install; then
                    successful_installations+=("ntlmrelayx (impacket)")
                else
                    failed_installations+=("ntlmrelayx (impacket)")
                fi
                cd ../
                ;;  

                16)
                # mitm6
                echo -e "\n\033[1m[*] Installing dependencies \033[0m"
                cd /opt/
                git clone https://github.com/dirkjanm/mitm6
                cd mitm6
                pip install -r requirements.txt

                echo -e "\n\033[1m[*] Installing mitm6 \033[0m"
                if pip install mitm6; then
                    successful_installations+=("mitm6")
                else
                    failed_installations+=("mitm6")
                fi
                cd ../
                ;;  

                17)
                # ldapdomaindump
                echo -e "\n\033[1m[*] Installing dependencies \033[0m"
                cd /opt/
                pip install ldap3 dnspython future

                echo -e "\n\033[1m[*] Installing ldapdomaindump \033[0m"
                if pip install ldapdomaindump; then
                    successful_installations+=("ldapdomaindump")
                else
                    failed_installations+=("ldapdomaindump")
                fi
                cd ../
                ;;  
                18)
                # neo4j
                echo -e "\n\033[1m[*] Installing dependencies \033[0m"
                cd /opt/
                curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key |sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
                echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable 4.1" | sudo tee -a /etc/apt/sources.list.d/neo4j.list
                apt update
                echo -e "\n\033[1m[*] Installing neo4j \033[0m"
                if apt install neo4j -y; then
                    successful_installations+=("neo4j")
                else
                    failed_installations+=("neo4j")
                fi
                cd ../
                ;;  
                19)
                # bloodhound
                echo -e "\n\033[1m[*] Installing bloodhound \033[0m"
                cd /opt/
                
                if pip install bloodhound; then
                    successful_installations+=("bloodhound")
                else
                    failed_installations+=("bloodhound")
                fi
                cd ../
                ;; 
                20)
                # plumhound
                echo -e "\n\033[1m[*] Installing plumhound \033[0m"
                cd /opt/
                git clone https://github.com/PlumHound/PlumHound.git
                cd PlumHound
                if sudo pip3 install -r requirements.txt; then
                    successful_installations+=("plumhound")
                else
                    failed_installations+=("plumhound")
                fi
                cd ../
                ;; 
                21)
                # crackmapexec
                echo -e "\n\033[1m[*] Installing crackmapexec \033[0m"
                if snap install crackmapexec; then
                    successful_installations+=("crackmapexec")
                else
                    failed_installations+=("crackmapexec")
                fi
                ;;  
                22)
                # proxychains
                echo -e "\n\033[1m[*] Installing proxychains \033[0m"
                if apt-get install -y proxychains; then
                    successful_installations+=("proxychains")
                else
                    failed_installations+=("proxychains")
                fi
                ;;
                23)
                # sshuttle
                echo -e "\n\033[1m[*] Installing sshuttle \033[0m"
                if pip install sshuttle; then
                    successful_installations+=("sshuttle")
                else
                    failed_installations+=("sshuttle")
                fi
                ;;
                
        esac
    done

    # After all installations have been attempted, print a summary
    echo -e "\n\n\n\033[32mTools installed successfully:\033[0m"
    for tool in "${successful_installations[@]}"; do
        echo -e "\033[32m[*] $tool\033[0m"
        if [[ "$tool" == "responder" ]]; then
            echo -e "\033[32m    To run responder navigate to the Responder directory and run: python3 Responder.py\n\033[0m"
        fi
    done

    echo -e "\n\033[31mTools not installed due to errors:\033[0m"
    for tool in "${failed_installations[@]}"; do
        echo -e "\033[31m[!] $tool\033[0m"
        if [[ "$tool" == "BurpSuite" ]]; then
            echo -e "\n\033[31mTo install BurpSuite please download the installer from:\nhttps://portswigger.net/burp/communitydownload?requestSource=communityDownloadPage\nThen:\n- chmod +x file.sh \n- ./file.sh  \033[0m"
        fi

        if [[ "$tool" == "crackmapexec" ]]; then
            echo -e "\n\033[31mTo install crackmapexec you need to have snap  \033[0m"
        fi
    done 
    echo ""
fi
