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
# Stolen from online. Differnet package managers
# Declare an array, and map values 
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt-get
#osInfo[/etc/alpine-release]=apk # Not avalable on Alpine linux
#osInfo[/etc/SuSE-release]=zypp
#osInfo[/etc/gentoo-release]=emerge

PKG="apt-get"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then # Could move the ifs in here.
        PKG=${osInfo[$f]}
        if [ "$PKG" = "apt-get" ] | [ "$PKG" = "yum" ]; then
          $PKG install glusterfs
        elif [ "$PKG" = "pacman" ]; then
          echo "We Have more issues"
        fi
        break
    fi
done

apt-get install glusterfs-server -y

# Create Backups of configs
mkdir /backups/config/gluster
cp -r /etc/glusterfs /backups/config/gluster

# Enable and Start 
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