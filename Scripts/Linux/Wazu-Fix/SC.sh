#! /bin/bash

# Modprobe : Removing support for unneeded filesystem types reduces the local attack surface of the server. If this filesystem type is not needed, disable it.
# Filesystems
# CRAM
1) Edit or create a file in the /etc/modprobe.d/ directory ending in .conf and add the following line: install cramfs /bin/true. 
2) Run the following command to unload the cramfs module: # rmmod cramfs

# remove freevx filesystem
Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vi /etc/modprobe.d/freevxfs.conf and add the following line: install freevxfs /bin/true 
Run the following command to unload the freevxfs module: # rmmod freevxfs

# Remove jffs2
Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vi /etc/modprobe.d/jffs2.conf and add the following line: install jffs2 /bin/true 
Run the following command to unload the jffs2 module: # rmmod jffs2

# remove hfs
Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vi /etc/modprobe.d/hfs.conf and add the following line: install hfs /bin/true 
Run the following command to unload the hfs module: # rmmod hfs

# Remove hfsplus
Edit or create a file in the /etc/modprobe.d/ directory ending in .confExample: vi /etc/modprobe.d/hfsplus.conf and add the following line: install hfsplus /bin/true 
Run the following command to unload the hfsplus module: # rmmod hfsplus
# remove udf
Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vi /etc/modprobe.d/udf.conf and add the following line: install udf /bin/true 
Run the following command to unload the udf module: # rmmod udf

# The /tmp directory is a world-writable directory used for temporary storage by all users and some applications.
Configure /etc/fstab as appropriate. Example: tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0 or 
Run the following commands to enable systemd /tmp mounting: 
systemctl unmask tmp.mount 
systemctl enable tmp.mount 
Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to configure the /tmp mount: [Mount] What=tmpfs Where=/tmp Type=tmpfs Options=mode=1777,strictatime,noexec,nodev,nosuid	

# Node The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /tmp: # mount -o remount,nodev /tmp     OR      
OR
Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to add nodev to the /tmp mount options:  [Mount]   Options=mode=1777,strictatime,noexec,nodev,nosuid 
Run the following command to restart the systemd daemon: #  systemctl daemon-reload	

# The nosuid mount option specifies that the filesystem cannot contain setuid files.
Edit the /etc/fstab file and add nosuid to the fourth field (mounting options) for the /tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /tmp: # mount -o remount,nosuid /tmp       
OR
Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to add nosuidto the /tmp mount options:
[Mount]  Options=mode=1777,strictatime,noexec,nodev,nosuid  
Run the following command to remount /tmp:
# mount -o remount,nosuid /tmp

# The noexec mount option specifies that the filesystem cannot contain executable binaries.
Edit the /etc/fstab file and add noexec to the fourth field (mounting options) for the /tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /tmp: # mount -o remount,noexec /tmp      
 OR
 Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to add noexec to the /tmp mount options: 
[Mount]  Options=mode=1777,strictatime,noexec,nodev,nosuid 
Run the following command to remount /tmp: # mount -o remount,noexec /tmp

# /dev/shm is a traditional shared memory concept. One program will create a memory portion, which other processes (if permitted) can access. Mounting tmpfs at /dev/shmis handled automatically by systemd.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. \
Run the following command to remount /dev/shm: # mount -o remount,nodev /dev/shm	

#The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. 
Run the following command to remount /dev/shm: # mount -o remount,nodev /dev/shm	

# The nosuid mount option specifies that the filesystem cannot contain setuid files.
Edit the /etc/fstab file and add nosuid to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. 
Run the following command to remount /dev/shm: # mount -o remount,nosuid /dev/shm	

# The noexec mount option specifies that the filesystem cannot contain executable binaries.
Edit the /etc/fstab file and add noexec to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. Run the following command to remount /dev/shm: # mount -o remount,noexec /dev/shm	

# The /var directory is used by daemons and other system services to temporarily store dynamic data. Some directories created by these processes may be world-writable.-- No
For new installations, during installationcreate a custom partition setup and specify a separate partition for /var. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	

# The /var/tmp directory is a world-writable directory used for temporary storage by all users and some applications. -- No
For new installations, during installation create a custom partition setup and specify a separate partition for /var/tmp. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	

# The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /var/tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /var/tmp : # mount -o remount,nodev /var/tmp	

# The nosuid mount option specifies that the filesystem cannot contain setuid files.
Edit the /etc/fstab file and add nosuid to the fourth field (mounting options) for the /var/tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /var/tmp: # mount -o remount,nosuid /var/tmp	
# The noexec mount option specifies that the filesystem cannot contain executable binaries.
Edit the /etc/fstab file and add noexec to the fourth field (mounting options) for the /var/tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /var/tmp: # mount -o remount,noexec /var/tmp	
# The /var/log directory is used by system services to store log data.
For new installations, during installation create a custom partition setup and specify a separate partition for /var/log.	
# The auditing daemon, auditd, stores log data in the /var/log/audit directory.
For new installations, during installation create a custom partition setup and specify a separate partition for /var/log/audit. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	
# The /home directory is used to support disk storage needs of local users.
For new installations, during installation create a custom partition setup and specify a separate partition for /home. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	
# The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /home partition. See the fstab(5) manual page for more information. # mount -o remount,nodev /home	



# Protocols
#Ensure DCCP is disabled.	
#Ensure SCTP is disabled.	
#Ensure RDS is disabled.	
#Ensure TIPC is disabled.	


# auto mount -- Will this mess with docker or anything?
# Run one of the following commands:  Run the following command to disable autofs: # systemctl --now disable autofs    OR  Run the following command to remove autofs:  # apt purge autofs
systemctl --now disable autofs

# Dont care?
# USB storage provides a means to transfer and store files insuring persistence and availability of the files independent of network connection status. Its popularity and utility has led to USB-based malware being a simple and common means for network infiltration and a first step to establishing a persistent threat within a networked environment.
Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vi /etc/modprobe.d/usb_storage.conf and 
add the following line: # install usb-storage /bin/true . 
Run the following command to unload the usb-storage module: # rmmod usb-storage	

# install aid 
# ubuntu
echo aide-common aideinit/copynew boolean false
echo aide-common aide/aideinit boolean false
echo aide-common aideinit/overwritenew boolean true

apt install aide aide-common -y
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Create Cron monitoring 


# Bootloader Permissions
chown root:root /boot/grub2/grub.cfg 
chmod og-rwx /boot/grub2/grub.cfg

# Script -- 
# Single User Mode 
sed -i "s|ExecStart.*|ExecStart=-/bin/sh -c '/sbin/sulogin; /usr/bin/systemctl --fail --no-block default'|g" /usr/lib/systemd/system/rescue.service
sed -i "s|ExecStart.*|ExecStart=-/bin/sh -c '/sbin/sulogin; /usr/bin/systemctl --fail --no-block default'|g" /usr/lib/systemd/system/emergency.service
#<< They just want us to set a password on the root account...>>


Run the following command to restore binaries to normal: # prelink -ua Uninstall prelink using the appropriate package manager or manual installation: # apt purge prelink	prelink is a program that modifies ELF shared libraries and ELF dynamically linked binaries in such a way that the time needed for the dynamic linker to perform relocations at startup significantly decreases.
################# LINE 34

# Security Update 
apt -s upgrade

# Time Synchronization NTP Install ntp or chrony
if [ "$(systemctl is-enabled systemd-timesyncd)" != "disabled" ]; then
    apt install chrony # Need to configure files and everything
    timedatectl set-ntp on
fi

# Ensure RPC is not installed.

#Disable IPv6.

#Ensure wireless interfaces are disabled.	nmcli radio wifi,nmcli radio wwan


# Sys
#Ensure packet redirect sending is disabled.	sysctl net.ipv4.conf.all.send_redirects
#Ensure IP forwarding is disabled.	sysctl net.ipv4.ip_forward
#Ensure source routed packets are not accepted.	sysctl net.ipv4.conf.all.accept_source_route,sysctl net.ipv4.conf.default.accept_source_route,grep -Rh net\.ipv4\.conf\.all\.accept_source_route /etc/sysctl.conf /etc/sysctl.d
#Ensure ICMP redirects are not accepted.	sysctl net.ipv4.conf.all.accept_redirects,sysctl net.ipv4.conf.default.accept_redirects
#Ensure secure ICMP redirects are not accepted.	sysctl net.ipv4.conf.all.secure_redirects
#Ensure suspicious packets are logged.	sysctl net.ipv4.conf.all.log_martians
#Ensure broadcast ICMP requests are ignored.	sysctl net.ipv4.icmp_echo_ignore_broadcasts,grep -Rh net\.ipv4\.icmp_echo_ignore_broadcasts /etc/sysctl.conf /etc/sysctl.d
#Ensure bogus ICMP responses are ignored.	sysctl net.ipv4.icmp_ignore_bogus_error_responses,grep -Rh net\.ipv4\.icmp_ignore_bogus_error_responses /etc/sysctl.conf /etc/sysctl.d
##Ensure Reverse Path Filtering is enabled.	sysctl net.ipv4.conf.all.rp_filter
#Ensure TCP SYN Cookies is enabled.	sysctl net.ipv4.tcp_syncookies,grep -Rh net\.ipv4\.tcp_syncookies /etc/sysctl.conf /etc/sysctl.d/*
#Ensure IPv6 router advertisements are not accepted.	sysctl net.ipv6.conf.all.accept_ra


# Iptables
# iptables -A INPUT -i lo -j ACCEPT 
# iptables -A OUTPUT -o lo -j ACCEPT 
# iptables -A INPUT -s 127.0.0.0/8 -j DROP --> this line after the lo accept


# Auditd
#Ensure auditing for processes that start prior to auditd is enabled.	-
#Ensure audit log storage size is configured.	-
#Ensure audit logs are not automatically deleted.	-
#Ensure system is disabled when audit logs are full.	-
#Ensure events that modify date and time information are collected.	-
#Ensure events that modify user/group information are collected.	-
#Ensure events that modify the system's network environment are collected.	-
#Ensure events that modify the system's Mandatory Access Controls are collected.	-
#Ensure login and logout events are collected.	-
#Ensure session initiation information is collected.	-
#Ensure discretionary access control permission modification events are collected.	-
#Ensure unsuccessful unauthorized file access attempts are collected.	-
#Ensure successful file system mounts are collected.	-
#Ensure file deletion events by users are collected.	-
#Ensure changes to system administration scope (sudoers) is collected.	-
#Ensure system administrator command executions (sudo) are collected.	-
#Ensure kernel module loading and unloading is collected.	-

#rsyslog
#Ensure rsyslog is installed.	dpkg -s rsyslog
#Ensure rsyslog Service is enabled.	systemctl is-enabled rsyslog
#Ensure rsyslog default file permissions configured.	-
#Ensure rsyslog is configured to send logs to a remote log host.	grep -Rh ^*.* /etc/rsyslog.conf /etc/rsyslog.d/
#Ensure remote rsyslog messages are only accepted on designated log hosts.	grep -Rh ^\$ModLoad[[:space:]]*imtcp /etc/rsyslog.conf /etc/rsyslog.d/


#journald
Ensure journald is configured to send logs to rsyslog.	-
Ensure journald is configured to compress large log files.	-
Ensure journald is configured to write logfiles to persistent disk.	-


# perm Log-- need to check
Ensure permissions on all logfiles are configured.	find /var/log -type f -ls

# Cron -- this is already implemented 
Ensure permissions on all logfiles are configured.	find /var/log -type f -ls
Ensure cron daemon is enabled and running.	systemctl is-enabled cron,systemctl status cron
Ensure permissions on /etc/crontab are configured.	stat /etc/crontab
Ensure permissions on /etc/cron.hourly are configured.	stat /etc/cron.hourly
Ensure permissions on /etc/cron.daily are configured.	stat /etc/cron.daily
Ensure permissions on /etc/cron.weekly are configured.	stat /etc/cron.weekly
Ensure permissions on /etc/cron.monthly are configured.	stat /etc/cron.monthly
Ensure permissions on /etc/cron.d are configured.	stat /etc/cron.d

Ensure at/cron is restricted to authorized users.	-
Ensure at is restricted to authorized users.	-


# sudo 
Ensure sudo is installed.	dpkg -s sudo
Ensure sudo commands use pty.	-
Ensure sudo log file exists.	-

# This or some of it may be done -- memeory 
Ensure permissions on /etc/ssh/sshd_config are configured.	stat /etc/ssh/sshd_config
Ensure permissions on SSH private host key files are configured.	stat /etc/ssh/ssh_host_rsa_key,stat /etc/ssh/ssh_host_ecdsa_key,stat /etc/ssh/ssh_host_ed25519_key
Ensure permissions on SSH public host key files are configured.	stat /etc/ssh/ssh_host_rsa_key.pub,stat /etc/ssh/ssh_host_ecdsa_key.pub,stat /etc/ssh/ssh_host_ed25519_key.pub
Ensure SSH access is limited.	sshd -T
Ensure SSH LogLevel is appropriate.	sshd -T
Ensure SSH X11 forwarding is disabled.	sshd -T
Ensure SSH MaxAuthTries is set to 4 or less.	sshd -T
Ensure SSH IgnoreRhosts is enabled.	sshd -T
Ensure SSH HostbasedAuthentication is disabled.	sshd -T
Ensure SSH root login is disabled.	sshd -T
Ensure SSH PermitEmptyPasswords is disabled.	sshd -T
Ensure SSH PermitUserEnvironment is disabled.	sshd -T
Ensure only strong ciphers are used.	sshd -T
Ensure only strong MAC algorithms are used.	sshd -T
Ensure only strong Key Exchange algorithms are used.	sshd -T
Ensure SSH Idle Timeout Interval is configured.	sshd -T
Ensure SSH LoginGraceTime is set to one minute or less.	sshd -T
Ensure SSH warning banner is configured.	sshd -T
Ensure SSH PAM is enabled.	sshd -T
Ensure SSH AllowTcpForwarding is disabled.	sshd -T
Ensure SSH MaxStartups is configured.	sshd -T
Ensure SSH MaxSessions is limited.	sshd -T


# PAM -- need to do this 
Ensure password creation requirements are configured.	-
Ensure lockout for failed password attempts is configured.	-
Ensure password reuse is limited.	-
Ensure password hashing algorithm is SHA-512.	-
Ensure minimum days between password changes is configured.	-
Ensure password expiration is 365 days or less.	-
Ensure password expiration warning days is 7 or more.	-
Ensure inactive password lock is 30 days or less.	useradd -D
Ensure default group for the root account is GID 0.	-
Ensure default user umask is 027 or more restrictive.	sh -c "umask"
Ensure default user shell timeout is 900 seconds or less.	-


# Su
Ensure access to the su command is restricted.	-

# Perms -- On memeory this appears to be done 
Ensure permissions on /etc/passwd are configured.	stat /etc/passwd
Ensure permissions on /etc/passwd- are configured.	stat /etc/passwd-
Ensure permissions on /etc/group are configured.	stat /etc/group
Ensure permissions on /etc/group- are configured.	stat /etc/group-
Ensure permissions on /etc/shadow are configured.	stat /etc/shadow
Ensure permissions on /etc/shadow- are configured.	stat /etc/shadow-
Ensure permissions on /etc/gshadow are configured.	stat /etc/gshadow
Ensure permissions on /etc/gshadow- are configured.	stat /etc/gshadow-

# Password This
Ensure password fields are not empty.	-
Ensure root is the only UID 0 account.	-
Ensure shadow group is empty.	 sh -c "awk -F: -v GID=\"$(awk -F: '($1==\"shadow\") {print $3}' /etc/group)\" '($4==GID) {print $1}' /etc/passwd"




