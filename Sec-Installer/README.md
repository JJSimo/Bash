# Sec-Installer

This script is designed to install security tools on a Ubuntu system.

It will prompt the user to update and upgrade the system.

Then it will ask the user to select which security tools to install 

## How to use it
To use this script and install also the tools that require Go, you need to:
- install go --> https://go.dev/doc/install
- set /usr/local/go/bin to the PATH --> `export PATH=$PATH:/usr/local/go/bin`

If you already have Go or in any case you have to
- find your go location -->  `locate go`
- **substitute** the previous command output in all the tools inside the scripts that need Go:
    - assetfinder
    - httprobe
    - GoWitness
    - subjack
