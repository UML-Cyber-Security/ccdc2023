#! /bin/bash
# Installs Glusterfs, starts and enables the service

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install 
apt-get install glusterfs-server -y
systemctl enable glusterd
systemctl start glusterd

# Create Gluster directory and Inital Brick
mkdir -p /gluster/brick