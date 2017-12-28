#!/bin/bash
cd /tmp

echo "Onboard Linux VM start" > onboard_vm.txt

echo hello > "script_start.txt"
wget https://github.com/Microsoft/omi/releases/download/v1.4.1-0/omi-1.4.1-0.ssl_100.ulinux.x64.deb
dpkg -i ./omi-1.4.1-0.ssl_100.ulinux.x64.deb

wget https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-294/dsc-1.1.1-294.ssl_100.x64.deb
dpkg -i ./dsc-1.1.1-294.ssl_100.x64.deb

# Params:
# $1 = Azure Automation Key
# $2 = Azure Automation Endpoint
# $3 = Optional, DSC Config to apply. Leave blank to just onboard VM
/opt/microsoft/dsc/Scripts/Register.py $1 $2 $3

echo "Onboard Linux VM complete" >> onboard_vm.txt