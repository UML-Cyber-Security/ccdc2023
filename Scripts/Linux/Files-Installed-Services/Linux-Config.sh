touch /etc/sysctl.d/ccdc.conf
chown root:root /etc/sysctl.d/ccdc.conf
chmod 644 /etc/sysctl.d/ccdc.conf
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.d/ccdc.conf #Log suspicious packets
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/ccdc.conf #Ignore ICMP Broadcasts
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/ccdc.conf #Ignore bogus ICMP responses
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf # Reverse path filtering
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf #Reverse path filtering
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/ccdc.conf #Enable syn cookies 
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.d/ccdc.conf #Enable ASLR

# If this is removed what does this do?
# systemctl --now disable rsync #rsync is considered insecure
# systemctl --now disable nis # to quote wazuh "NIS is inherently an insecure system"

aa-enforce /etc/apparmor.d/* #Set AppArmor

sysctl -w net.ipv4.route.flush=1
sysctl -w kernel.randomize_va_space=2