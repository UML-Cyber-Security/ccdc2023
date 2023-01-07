# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; 
    then apt-get purge ldap-utils -y
    else yum remove rsyslog -y
fi
