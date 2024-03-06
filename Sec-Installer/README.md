# Sec-Installer

This script is designed to install security tools on a Ubuntu system.

It will prompt the user to update and upgrade the system.

Then it will ask the user to select which security tools to install 

## How to use it
To use this script and install also the tools that require Go, you need to:
- install go --> https://go.dev/doc/install
- set /usr/local/go/bin to the PATH --> `export PATH=$PATH:/usr/local/go/bin`

To install BurpSuite you need to :
- donwload the installer from --> https://portswigger.net/burp/communitydownload?requestSource=communityDownloadPage
- put the installer inside the folder in which you run this script
- modify in the script the `version`, `architecture` and `v`variables (based on the downloaded version)
