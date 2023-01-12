#! /bin/bash

if [ -f /var/log/health-check.log ]; then 
    touch /var/log/health-check.log
    chmod 644 /var/log/health-check.log
    chown root:root /var/log/health-check.log
fi

# Get the system's IP address 
IP4="$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)"

if [ "$(systemctl status docker | grep "active (running)" | wc -l)" -eq 0 ]; then 
    logger -t "[Health-Check-Docker]" " Service is incative"
fi

if [ "$(systemctl status auditd | grep "active (running)" | wc -l)" -eq 0 ]; then 
    logger -t "[Health-Check-Auditd]" "Service is incative"
fi

if [ "$(systemctl status glusterd | grep "active (running)" | wc -l)" -eq 0 ]; then 
    logger -t "[Health-Check-Glusterd]" "Service is incative"
fi

if [ "$(systemctl status sshd | grep "active (running)" | wc -l)" -eq 0 ]; then 
    logger -t "[Health-Check-SSHD]" "Service is incative"
fi

if [ "$(systemctl status cron | grep "active (running)" | wc -l)" -eq 0 ]; then 
    logger -t "[Health-Check-Cron]" "Service is incative"
fi

if [ "$(systemctl status wazuh-agent | grep "active (running)" | wc -l)" -eq 0 ]; then 
    logger -t "[Health-Wazuh-Agent]" "Service is incative"
fi

# auditd -- make sure all rules are loaded
if [ "$(auditctl -l | wc -l )" -ne 39 ]; then 
    logger -p WARN -t "[Health-Check-Auditd]" "Service has malformed rules"
fi

# now onto pain -- the sysctl configurations

if [ "$(sysctl -n net.ipv4.conf.all.send_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.all.send_redirects"
fi

if [ "$(sysctl -n net.ipv4.conf.default.send_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.default.send_redirects"
fi

if [ "$(sysctl -n net.ipv4.conf.all.accept_source_route)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.all.accept_source_route"
fi

if [ "$(sysctl -n net.ipv4.conf.default.accept_source_route)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.default.accept_source_route"
fi

if [ "$(sysctl -n net.ipv6.conf.all.accept_source_route)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv6.conf.all.accept_source_route"
fi

if [ "$(sysctl -n net.ipv6.conf.default.accept_source_route)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv6.conf.default.accept_source_route"
fi

if [ "$(sysctl -n net.ipv4.conf.all.accept_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.all.accept_redirects"
fi

if [ "$(sysctl -n net.ipv4.conf.default.accept_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.default.accept_redirects"
fi

if [ "$(sysctl -n net.ipv6.conf.all.accept_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv6.conf.all.accept_redirects"
fi

if [ "$(sysctl -n net.ipv6.conf.default.accept_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv6.conf.default.accept_redirects"
fi

if [ "$(sysctl -n net.ipv4.conf.all.secure_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.all.secure_redirects"
fi

if [ "$(sysctl -n net.ipv4.conf.default.secure_redirects)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.default.secure_redirects"
fi

if [ "$(sysctl -n net.ipv4.conf.all.log_martians)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.all.log_martians"
fi

if [ "$(sysctl -n net.ipv4.conf.default.log_martians)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.default.log_martians"
fi

if [ "$(sysctl -n net.ipv4.icmp_echo_ignore_broadcasts)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.icmp_echo_ignore_broadcasts"
fi

if [ "$(sysctl -n net.ipv4.icmp_ignore_bogus_error_responses)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.icmp_ignore_bogus_error_responses"
fi

if [ "$(sysctl -n net.ipv4.conf.all.rp_filter)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.all.rp_filter"
fi

if [ "$(sysctl -n net.ipv4.conf.default.rp_filter)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.conf.default.rp_filter"
fi

if [ "$(sysctl -n net.ipv4.tcp_syncookies)" -eq 1 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv4.tcp_syncookies"
fi

if [ "$(sysctl -n net.ipv6.conf.all.accept_ra)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv6.conf.all.accept_ra"
fi

if [ "$(sysctl -n net.ipv6.conf.default.accept_ra)" -eq 0 ]; then 
    logger -t "[Health-Check-sysctl]" "Service has malformed rules net.ipv6.conf.default.accept_ra"
fi




