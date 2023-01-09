#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    apt-get -q install rsyslog -y
elif [ -f "/etc/redhat-release" ]; then
    yum install rsyslog -y
elif [ -f "/etc/arch-release" ]; then
    echo "Arch, Will this come up -- probably should do fedora"
fi
# Enable syslog
systemctl --now enable rsyslog
# Some settings -- Note
sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.conf
sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.d/*.conf