#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
green_bg='\033[42m'
yellow='\033[1;33m'
NC='\033[0m'
echo_red () { echo -e "${red}$1${NC}"; }
echo_green () { echo -e "${green}$1${NC}"; }
echo_green_bg () { echo -e "${green_bg}$1${NC}"; }
echo_yellow () { echo -e "${yellow}$1${NC}"; }

echo -e "Adding ${green}coral-cloud-stable${NC} to apt sources"
echo "deb https://packages.cloud.google.com/apt coral-cloud-stable main" | sudo tee /etc/apt/sources.list.d/coral-cloud.list

echo -e "Adding ${yellow}Google Cloud${NC} apt-key.gpg"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo -e "${yellow}Starting update...${NC}"
sudo apt update
sudo apt upgrade

echo -e "${yellow}Running firmware downgrade sequence...${NC}"
curl -fsSL https://gist.githubusercontent.com/psyke83/cb3ca50561480809c246f42727cb7cf2/raw/5343bae57783ad855629b3acd5c238b2871edc87/downgrade_firmware.sh | sudo bash downgrade
curl -fsSL https://gist.githubusercontent.com/psyke83/cb3ca50561480809c246f42727cb7cf2/raw/5343bae57783ad855629b3acd5c238b2871edc87/downgrade_firmware.sh | sudo bash block

echo -e "Removing any prior remnant of ${green}python3-coral-enviro${NC}..."
sudo apt remove python3-coral-enviro

echo -e "Cleaning packages..."
sudo apt-get autoclean
sudo apt-get autoremove

echo -e "Re-installing ${green}python3-coral-enviro${NC}..."
sudo apt install python3-coral-enviro

echo -e "Starting ${red}reboot${NC}..."
sudo reboot
