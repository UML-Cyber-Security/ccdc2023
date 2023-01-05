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

# Limit number of bricks 
sed -i 's/.*base-port.*/   option base-port 49152/g' /etc/glusterfs/glusterd.vol
sed -i 's/.*max-port.*/    option max-port 49162/g' /etc/glusterfs/glusterd.vol

GLUSTER=$(iptables -nvL | grep "GLUSTER" | wc -l ) 
echo $GLUSTER
if [ "$GLUSTER" != 0 ]
  then echo "Appending Gluster Firewall Chains to the Firewall"
  iptables -A INPUT -j GLUSTER-IN
  iptables -A OUTPUT -j GLUSTER-OUT
  ip6tables -A INPUT -j GLUSTER-IN
  ip6tables -A OUTPUT -j GLUSTER-OUT
fi


# Create Gluster directory and Inital Brick
echo "Creating Gluster Directory in Root Directory for Brick Dirs"
mkdir -p /gluster/brick1

systemctl restart glusterd