#!/bin/bash	

if [[ $EUID -ne 0 ]]; then
	echo "[!] This script must be run as root"
	exit 1
else
	if [ $# -lt 1 ];then
		echo "[!] Usage: ./run.sh <URL>"
		exit 1
	else
		url=$1                                                          # first argument is the URL
		if [ ! -d "$url" ];then                                         # if the directory for the result does not exist => create it
			mkdir $url
		fi
		if [ ! -d "$url/recon" ];then                                   # if the directory recon does not exist => create it
			mkdir $url/recon
		fi
		if [ ! -d "$url/recon/scans" ];then
			mkdir $url/recon/scans
		fi
		if [ ! -d "$url/recon/httprobe" ];then
			mkdir $url/recon/httprobe
		fi
		if [ ! -d "$url/recon/potential_takeovers" ];then
			mkdir $url/recon/potential_takeovers
		fi
		if [ ! -d "$url/recon/wayback" ];then
			mkdir $url/recon/wayback
		fi
		if [ ! -d "$url/recon/wayback/params" ];then
			mkdir $url/recon/wayback/params
		fi
		if [ ! -d "$url/recon/wayback/extensions" ];then
			mkdir $url/recon/wayback/extensions
		fi
		if [ ! -f "$url/recon/httprobe/alive.txt" ];then
			touch $url/recon/httprobe/alive.txt
		fi
		if [ ! -f "$url/recon/final.txt" ];then
			touch $url/recon/final.txt
		fi
		
		echo "[*] Harvesting subdomains with assetfinder"
		assetfinder $url >> $url/recon/assets.txt                           # harvest subdomains and save them to a file inside the result directory
		cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt         # filter the subdomains to only include the ones that contain the URL
		rm $url/recon/assets.txt                                            # remove the file that contains all the subdomains  
		
		echo "[*] Probing for alive domains"
		cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/httprobe/a.txt              # check if subdomains are responding
                                                                                                                                                        # sed and tr remove https:// and :443 from the output
		sort -u $url/recon/httprobe/a.txt > $url/recon/httprobe/alive.txt                                                                               # remove duplicates and save the result to a file               
		rm $url/recon/httprobe/a.txt
		
		echo "[*] Checking for possible subdomain takeover"
		if [ ! -f "$url/recon/potential_takeovers/potential_takeovers.txt" ];then
			touch $url/recon/potential_takeovers/potential_takeovers.txt
		fi
		# subdomain takeover -->  check if there are subdomains that are pointing to a service that is no longer in use
        #                           - for example a subdomains whose payment has not been renewed
        #                           - => this attack can be used to purchase the domain and use it for malicious purposes
        #                           - => in this way you have got a subdomains inside the target domain
		subjack -w $url/recon/final.txt -t 100 -timeout 30 -ssl -c ~/go/src/github.com/haccer/subjack/fingerprints.json -v 3 -o $url/recon/potential_takeovers/potential_takeovers.txt
		
		echo "[*] Scanning for open ports"
		nmap -iL $url/recon/httprobe/alive.txt -T4 -oA $url/recon/scans/scanned.txt                                                                     # scan for open ports
		
		echo "[*] Scraping wayback data"                                                                                                                # scrape historical data
		cat $url/recon/final.txt | waybackurls >> $url/recon/wayback/wayback_output.txt
		sort -u $url/recon/wayback/wayback_output.txt
		
		echo "[*] Pulling and compiling all possible params found in wayback data"                                                                      # extract data from wayback output
		cat $url/recon/wayback/wayback_output.txt | grep '?*=' | cut -d '=' -f 1 | sort -u >> $url/recon/wayback/params/wayback_params.txt
		for line in $(cat $url/recon/wayback/params/wayback_params.txt);do echo $line'=';done
		
		echo "[*] Pulling and compiling js/php/aspx/jsp/json files from wayback output"
		for line in $(cat $url/recon/wayback/wayback_output.txt);do
			ext="${line##*.}"
			if [[ "$ext" == "js" ]]; then
				echo $line >> $url/recon/wayback/extensions/js1.txt
				sort -u $url/recon/wayback/extensions/js1.txt >> $url/recon/wayback/extensions/js.txt
			fi
			if [[ "$ext" == "html" ]];then
				echo $line >> $url/recon/wayback/extensions/jsp1.txt
				sort -u $url/recon/wayback/extensions/jsp1.txt >> $url/recon/wayback/extensions/jsp.txt
			fi
			if [[ "$ext" == "json" ]];then
				echo $line >> $url/recon/wayback/extensions/json1.txt
				sort -u $url/recon/wayback/extensions/json1.txt >> $url/recon/wayback/extensions/json.txt
			fi
			if [[ "$ext" == "php" ]];then
				echo $line >> $url/recon/wayback/extensions/php1.txt
				sort -u $url/recon/wayback/extensions/php1.txt >> $url/recon/wayback/extensions/php.txt
			fi
			if [[ "$ext" == "aspx" ]];then
				echo $line >> $url/recon/wayback/extensions/aspx1.txt
				sort -u $url/recon/wayback/extensions/aspx1.txt >> $url/recon/wayback/extensions/aspx.txt
			fi
		done
		
		rm $url/recon/wayback/extensions/js1.txt
		rm $url/recon/wayback/extensions/jsp1.txt
		rm $url/recon/wayback/extensions/json1.txt
		rm $url/recon/wayback/extensions/php1.txt
		rm $url/recon/wayback/extensions/aspx1.txt

        echo "[*] Running eyewitness against all compiled domains"
        python3 EyeWitness/EyeWitness.py --web -f $url/recon/httprobe/alive.txt -d $url/recon/eyewitness --resolve                                      # take screenshots of the domains
	fi
fi