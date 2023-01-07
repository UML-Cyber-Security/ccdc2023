# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; 
    then apt-get -q install rsyslog -y
    else yum install rsyslog -y
fi
# Enable syslog
systemctl --now enable rsyslog
# Some settings -- Note
sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.conf
sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.d/*.conf