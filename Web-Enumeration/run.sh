#!/bin/bash

url=$1                                                         # first argument is the URL

if [ ! -d "$url" ];then                                           # if the directory for the result does not exist => create it
    mkdir $url
fi

if [ ! -d "$url/recon" ];then                                    # if the directory recon does not exist => create it
    mkdir $url/recon
fi

echo "[*] Harvesting subdomains with assetfinder"
assetfinder $url >> $url/recon/assets.txt                       # harvest subdomains and save them to a file inside the result directory  
cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt     # filter the subdomains to only include the ones that contain the URL  
rm $url/recon/assets.txt                                        # remove the file that contains all the subdomains   