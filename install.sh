#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
green_bg='\033[42m'
blue_bg='\033[44m'
yellow='\033[1;33m'
NC='\033[0m'
echo_red () { echo -e "${red}$1${NC}"; }
echo_green () { echo -e "${green}$1${NC}"; }
echo_green_bg () { echo -e "${green_bg}$1${NC}"; }
echo_yellow () { echo -e "${yellow}$1${NC}"; }

echo -e "${blue_bg}Step 1:${NC} Adding ${green}coral-cloud-stable${NC} to apt sources"
echo "deb https://packages.cloud.google.com/apt coral-cloud-stable main" | sudo tee /etc/apt/sources.list.d/coral-cloud.list

echo -e "${blue_bg}Step 2:${NC} Adding ${yellow}Google Cloud${NC} apt-key.gpg"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo -e "${blue_bg}Step 3:${NC} ${yellow}Starting update...${NC}"
sudo apt update -y
sudo apt upgrade -y

echo -e "${blue_bg}Step 4:${NC} ${yellow}Running firmware downgrade sequence...${NC}"
curl -fsSL https://gist.githubusercontent.com/psyke83/cb3ca50561480809c246f42727cb7cf2/raw/5343bae57783ad855629b3acd5c238b2871edc87/downgrade_firmware.sh -o downgrade_firmware.sh
sudo chmod +x downgrade_firmware.sh
sudo ./downgrade_firmware.sh downgrade
sudo ./downgrade_firmware.sh block

echo -e "${blue_bg}Step 5:${NC} Removing any prior remnant of ${green}python3-coral-enviro${NC}..."
sudo apt remove python3-coral-enviro -y

echo -e "${blue_bg}Step 6:${NC} Cleaning packages..."
sudo apt-get autoclean -y
sudo apt-get autoremove -y

echo -e "${blue_bg}Step 7:${NC} Re-installing ${green}python3-coral-enviro${NC}..."
sudo apt install python3-coral-enviro -y

echo -e "${blue_bg}Step 8:${NC} Starting ${red}reboot${NC}..."
sudo reboot
