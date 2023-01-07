#! /bin/bash
# Pass a 1 or 0 to install cron allow list and or ldap
# ./SCRIP 1 1 install both 

##################### Instalations
# Install Python
# sudo apt-get install -q python3
# Make sure sudo is installed
apt-get -q install sudo -y

# Install UFW
# apt-get -q install ufw

##################### Purge
# Remove automounting untility
apt-get -q purge autofs -y
# Remove telnet from machine
apt purge telnet -y
# Remove Network Information Service from machine 
apt purge nis -y
# Remove Talk Service from machine 
apt purge talk -y 
# Remove rshell client from machine 
apt purge rsh-client -y

# Download list of packages to update.
apt-get -q update
# Install updated packages 
apt-get -q upgrade -y  