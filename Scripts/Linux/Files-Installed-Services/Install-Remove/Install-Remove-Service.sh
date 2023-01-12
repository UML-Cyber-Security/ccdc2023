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
    if [[ -f $f ]];then # Could move the ifs in here.
        PKG=${osInfo[$f]}
    fi
done

echo "Pkage manager is "$PKG

if [ "$PKG" = "apt-get" ]; then 
    export DEBIAN_FRONTEND=noninteractive
fi

#################### UPDATE
# Download list of packages to update.
$PKG update
$PKG upgrade -y # Need to check if this works.

##################### Instalations
# Install Python
# Make sure sudo is installed
# Install UFW -- note done 
if [ "$PKG" = "apt-get" ] | [ "$PKG" = "yum" ]; then   
    $PKG install python3 -y
    $PKG install sudo -y
    # $PKG install ufw -y
elif [ "$PKG" = "apk" ]; then
    # NEED TO ENABLE COMMUNITY REPOSITORY
    sed -i 's/^#\(.*community\)/\1/g' /etc/apk/repositories
    # Install Python and Pip3
    apk add --no-cache python3 py3-pip -y
    apk add sudo  -y
    # Edit sudoers file with basic allow.
    # Sudeoers need to be in the wheel group
    echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
    # apk add ufw -y
elif [ "PKG" = pacman ]; then
    echo "We probably have other problems..." 
fi
##################### Remove 
# Remove automounting untility
# Remove telnet from machine
# Remove Network Information Service from machine 
# Remove Talk Service from machine 
# Remove rshell client from machine 
if [ "$PKG" = "apt-get" ]; then
    apt-get purge autofs -y
    apt-get purge telnet -y
    apt-get purge nis -y
    apt-get purge talk -y 
    apt-get purge rsh-client -y
elif [ "$PKG" = "yum" ]; then
    yum remove autofs -y
    yum remove telnet -y
    yum remove nis -y
    yum remove talk -y
    yum remove rsh-client -y
elif [ "$PKG" = "apk" ]; then
    # Appears that apk will not ask for confirmation unless you use the --interactive flag
    apk del autofs 
    apk del telnet
    apk del nis
    apk del talk
    apk del rsh-client
elif [ "$PKG" = "pacman" ]; then
    echo "We probably have other problems..." 
fi
