#! /bin/bash
# Pass a 1 or 0 to install cron allow list and or ldap
# ./SCRIP 1 1 install both 

##################### Instalations
# Install Python
# sudo apt-get install -q python3
# Make sure sudo is installed
apt-get -q install sudo 
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


# [!] Switch to allow list for cron? (1/0 for y/n) "
# It is more secure but there may be additional modifications required"
if [ $1 -ne 0 ]; then
    rm /etc/at.deny
    rm /etc/cron.deny
    touch /etc/cron.allow
    touch /etc/at.allow
    chmod og-rwx /etc/cron.allow
    chmod og-rwx /etc/at.allow
    chown root:root /etc/cron.allow
    chown root:root /etc/at.allow
fi

# Will this machine be acting as an LDAP client? (1 for yes, 0 for no) 
# First Argument 
if [ $2 -eq 0 ]; then
    apt purge ldap-utils
fi

# Download list of packages to update.
apt-get -q update
# Install updated packages 
apt-get -q upgrade -y  