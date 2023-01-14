# If Debian
# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    apt-get install apparmor -y
elif [ -f "/etc/redhat-release" ]; then
    yum remove 
    yum install apparmor -y
elif [ -f "/etc/arch-release" ]; then
    echo "Arch, Will this come up -- probably should do fedora"
fi