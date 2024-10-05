#AUTHOR : Rahulsingh Kanoj
#created on 31/01/2022
#Email:rahulkanoj3@gmail.com



#!/bin/bash
echo " wait  for a while we are updating your system  "
set -e #terminates the process where error occurs
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get update -y
sudo snap install skype
sudo snap install zoom-client
sudo apt install curl 
sudo apt install wget
curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g @angular/cli@10.2.0 -y 
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update 
sudo apt-get install google-chrome-stable
sudo apt-get --purge autoremove firefox -y #To remove fire-fox 
sudo snap install --classic code 
sudo apt install git-all
sudo apt install openjdk-11-jre-headless -y
sudo snap install flutter --classic
sudo snap install --classic android-studio
sudo hostnamectl set-hostname aladmin #To set machine name
echo "please enter the user name in format 'al-14 (14=your laptop number)'" 
read user
sudo adduser $user
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker $user
sudo deluser $user sudo #remove sudo access to user 
sudo passwd -d root
echo "please enter root password contact your system admin "
sudo passwd root
cd /
sudo chmod 444 media #to remove usb access

echo "curl http://deb.kickidler.com/generic/repo.gpg | apt-key add -" > kick.txt
echo "echo "deb http://deb.kickidler.com/generic stable non-free" > /etc/apt/sources.list.d/kickidler.list"  >> kick.txt
echo "apt-get update" >> kick.txt
echo "apt-get install kickidlergrabber" >> kick.txt
sudo sh kick.txt #runs the script in root
#sudo snap install --classic eclipse
#export ANDROID_HOME=/usr/local/android-sdk-linux/
#export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platforms-tools
#npm install -g artillery --allow-root --unsafe-perm=true
