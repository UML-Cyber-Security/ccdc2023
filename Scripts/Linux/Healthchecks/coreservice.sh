#! /bin/bash

if [ -f /var/log/health-check.log ]; then 
    touch /var/log/health-check.log
    chmod 644 /var/log/health-check.log
    chown root:root /var/log/health-check.log
fi

# Get the system's IP address 
IP4="$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)"

# Get the current time
TIME="$(date)"

if [ "$(systemctl status docker | grep "active (running)" | wc -l)" -eq 0 ]; then 
    echo "[Health-Check-Docker]: $TIME : Service is incative - on machine with IP:$IP4"
fi

if [ "$(systemctl status auditd | grep "active (running)" | wc -l)" -eq 0 ]; then 
    echo "[Health-Check-Auditd]: $TIME : Service is incative - on machine with IP:$IP4"
fi

if [ "$(systemctl status glusterd | grep "active (running)" | wc -l)" -eq 0 ]; then 
    echo "[Health-Check-Glusterd]: $TIME : Service is incative - on machine with IP:$IP4"
fi

if [ "$(systemctl status sshd | grep "active (running)" | wc -l)" -eq 0 ]; then 
    echo "[Health-Check-SSHD]: $TIME : Service is incative - on machine with IP:$IP4"
fi

if [ "$(systemctl status cron | grep "active (running)" | wc -l)" -eq 0 ]; then 
    echo "[Health-Check-Cron]: $TIME : Service is incative - on machine with IP:$IP4"
fi



# auditd -- make sure all rules are loaded
if [ "$(auditctl -l | wc -l )" -ne 39 ]; then 
    echo "[Health-Check-Auditd]: $TIME : Service has malformed rules - on machine with IP:$IP4"
fi

# now onto pain -- the sysctl configurations

