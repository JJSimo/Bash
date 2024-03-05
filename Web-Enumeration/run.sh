#!/bin/bash
if [[ $EUID -ne  0 ]]; then
    echo "[!] This script must be run as root"  
    exit  1
else

    if [ $# -lt 1 ];then
        echo "[!] Usage: ./run.sh <URL>"
        exit 1
    else
        url=$1                                                         # first argument is the URL
        if [ ! -d "$url" ]; then                                       # if the directory for the result does not exist => create it
            mkdir $url
        fi

        if [ ! -d "$url/recon" ]; then                                 # if the directory recon does not exist => create it
            mkdir $url/recon
        fi

        echo "[*] Harvesting subdomains with assetfinder"
        assetfinder $url >> $url/recon/assets.txt                       # harvest subdomains and save them to a file inside the result directory  
        cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt     # filter the subdomains to only include the ones that contain the URL  
        rm $url/recon/assets.txt                                        # remove the file that contains all the subdomains  
        
        #echo "[*] Harvesting subdomains with Amass"
        #amass enum -d $url >> $url/recon/amass.txt        
        #sort -u $url/recon/amass.txt >> $url/recon/final.txt   
        #rm $url/recon/amass.txt

        echo "[*] Probing for alive subdomains"
        cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/alive.txt
    fi
fi