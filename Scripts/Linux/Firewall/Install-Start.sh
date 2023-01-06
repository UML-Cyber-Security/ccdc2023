#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; 
    then apt-get -q install iptables -y
    else yum install iptables-services -y
fi

if [ "$(systemctl status firewalld | grep 'active' | wc -l)" -ne 0 ]; then
    systemctl disable firewalld
    systemctl mask firewalld
    systemctl stop firewalld
fi
systemctl start iptables && systemctl start ip6tables