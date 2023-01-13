#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Stolen from online. Differnet package managers
# Declare an array, and map values 
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk
#osInfo[/etc/SuSE-release]=zypp
#osInfo[/etc/gentoo-release]=emerge

PKG="apt-get"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PKG=${osInfo[$f]}
    fi
done


if [ "$PKG" = "apt-get" ]; then
    export DEBIAN_FRONTEND=noninteractive
    # Remove old version? 
    # sudo apt-get remove docker docker-engine docker.io containerd runc
    
    # install dcoker engine and compose
    # apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    apt-get install docker.io -y
    apt-get install docker-compose-plugin
    # Start docker 
    systemctl start docker
elif  [ "$PKG" = "yum" ]; then
    # Remove old versions?
    #sudo yum remove docker \ docker-client \ docker-client-latest \ docker-common \ docker-latest \ docker-latest-logrotate \ docker-logrotate \ docker-engine

    # Install yumutils and add repository for docker 
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # install docker engine and compose -- installs podman
    #yum install -y docker 
    #yum install -y docker-compose-plugin
    
    # installs docker
    yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    # start docker # RHEL installs podman
    systemctl enable --now docker

elif [ "$PKG" = "apk" ]; then
    # Install Docker
    apk add --update docker openrc
    
    # Start Docker Service
    service docker start
elif [ "$PKG" = "pacman" ]; then
    # Download -- Need to specify version and architecture 
   #pacman -U ./docker-desktop-<version>-<arch>.pkg.tar.zst
    echo "No"
    # Start service 
    #systemctl --user start docker-desktop
fi

# Need to run the Script to setup the Docker Firewall.