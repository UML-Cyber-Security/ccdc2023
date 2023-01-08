#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
##############------------ Move commands to respective sections!

# Modprobe : Removing support for unneeded filesystem types reduces the local attack surface of the server. If this filesystem type is not needed, disable it.
# Filesystems
# Remove CRAM Filesystem
touch /etc/modprobe.d/cramfs.conf
echo "install cramfs /bin/true" > /etc/modprobe.d/cramfs.conf
rmmod cramfs

# Remove freevx filesystem
touch /etc/modprobe.d/cramfs.conf 
echo "install freevxfs /bin/true" > /etc/modprobe.d/cramfs.conf 
rmmod freevxfs

# Remove jffs2 Filesystem
touch /etc/modprobe.d/jffs2.conf 
echo "install jffs2 /bin/true" > /etc/modprobe.d/jffs2.conf 
rmmod jffs2

# Remove hfs Filesystem
touch /etc/modprobe.d/hfs.conf 
echo "install hfs /bin/true" > /etc/modprobe.d/hfs.conf 
rmmod hfs

# Remove hfsplus Filesystem
touch /etc/modprobe.d/hfsplus.conf 
echo "install hfsplus /bin/true" > /etc/modprobe.d/hfsplus.conf 
rmmod hfsplus

# Remove udf
touch /etc/modprobe.d/udf.conf
echo "install udf /bin/true" > /etc/modprobe.d/hfsplus.conf 
rmmod udf

# Dont care?
# USB storage provides a means to transfer and store files insuring persistence and availability of the files independent of network connection status. Its popularity and utility has led to USB-based malware being a simple and common means for network infiltration and a first step to establishing a persistent threat within a networked environment.
touch /etc/modprobe.d/usb_storage.conf 
echo "install usb-storage /bin/true" > /etc/modprobe.d/usb_storage.conf  
rmmod usb-storage	

#Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vim /etc/modprobe.d/dccp.conf and add the following line: install dccp /bin/true
#Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vim /etc/modprobe.d/sctp.conf and add the following line: install sctp /bin/true
#Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vim /etc/modprobe.d/rds.conf and add the following line: install rds /bin/true
#Edit or create a file in the /etc/modprobe.d/ directory ending in .conf Example: vim /etc/modprobe.d/tipc.conf and add the following line: install tipc /bin/true

###############################################################

# auto mount -- Will this mess with docker or anything?
# Run one of the following commands:  Run the following command to disable autofs: # systemctl --now disable autofs    OR  Run the following command to remove autofs:  # apt purge autofs
systemctl --now disable autofs # Already handeled 

# Undo Prelinks
prelink -ua Uninstall prelink
# Remove Prelink -- System Specific?
apt purge prelink -y

####################################################
# Resttict core dumps 
sed -i 's/\(.* End of file\)/* hard core 0\n\1/g' /etc/security/limits.conf
echo "fs.suid_dumpable = 0" >> /etc/sysctl.d/ccdc.conf 
# Apply sysctl config ((This is in the file))

#######################################################
#Edit the /etc/motd file with the appropriate contents according to your site policy, remove any instances of \m , \r , \s , \v or references to the OS platform OR If the motd is not used, this file can be removed. Run the following command to remove the motd file: # rm /etc/motd
sed -i 's#[\/m|\/r|\/s|\/v]##g' /etc/motd
#remove references to the OS platform 

sed -i 's#[\/m|\/r|\/s|\/v]##g' /etc/issue
#or references to the OS platform  # They have > in the echo which will bash the contents inside already.
echo "Authorized uses only. All activity may be monitored and reported." >> /etc/issue

sed -i 's#[\/m|\/r|\/s|\/v]##g' /etc/issue.net
#references to the OS platform:
echo "Authorized uses only. All activity may be monitored and reported." >> /etc/issue.net

# Change motd permissions 
chown root:root /etc/motd 
chmod u-x,go-wx /etc/motd

chown root:root /etc/issue 
chmod u-x,go-wx /etc/issue

chown root:root /etc/issue.net 
chmod u-x,go-wx /etc/issue.net

#### GUI Message
 if [ -f "/etc/gdm3/greeter.dconf-defaults" ]; then 
    echo "[org/gnome/login-screen], banner-message-enable=true, banner-message-text='Authorized uses only. All activity may be monitored and reported.'" >> /etc/gdm3/greeter.dconf-defaults


# Time Synchronization 
#apt install chrony # -- UBUNTU 
# Add Server line to  /etc/chrony/chrony.conf
	#   server 0.us.pool.ntp.org
	#   server 1.us.pool.ntp.org
	#   server 2.us.pool.ntp.org
	#   server 3.us.pool.ntp.org
#systemctl --now mask systemd-timesyncd


# Remove XServer--Ubuntu
apt purge xserver-xorg*

# avahi automated network device discovery
# Stop disable
systemctl --now disable avahi-daemon
systemctl stop avahi-daemon.socket
# Remove --Ubuntu
apt purge avahi-daemon

# CUPS, no printers--Ubuntu
apt purge cups

# isc-dhcp-server -- Remove DHCP Serve capablilities --Ubuntu
apt purge isc-dhcp-server

# LDAP server removal --Ubuntu
apt purge slapd

# Remove Network File Server --Ubuntu
apt purge nfs-kernel-server

# Remove DNS -- Some
apt purge bind9

# Remove FTPserver -- All probably
apt purge vsftpd

# Remove apache server
apt purge apache2

# Dotcove --Ubuntu IMAP POP3 (mail access servers) --Some 
apt purge dovecot-imapd dovecot-pop3d

# Remove Samba server
apt purge samba

# Remove squid proxy server 
apt purge squid

# Remove simple network management server 
apt purge snmpd

# Remove RPC client
apt purge rpcbind

# Disable IPv6
#Edit /etc/default/grub and add ipv6.disable=1 to the GRUB_CMDLINE_LINUX parameters: GRUB_CMDLINE_LINUX="ipv6.disable=1" Run the following command to update the grub2 configuration: # update-grub
sed "s/GRUB_CMDLINE_LINUX=\"ipv6.disable=1\"" >>  /etc/default/grub # sed find and replace? need to look at example  
update-grub

#Edit /etc/exim4/update-exim4.conf and and or modify following lines to look like the lines below: dc_eximconfig_configtype='local' dc_local_interfaces='127.0.0.1 ; ::1' dc_readhost='' dc_relay_domains='' dc_minimaldns='false' dc_relay_nets='' dc_smarthost='' dc_use_split_config='false' dc_hide_mailname='' dc_mailname_in_oh='true' dc_localdelivery='mail_spool' Restart exim4: # systemctl restart exim4


# Disable wireless interfaces 
# nmcli radio all off # Not needed 


# Remove 
# Protocols
#Ensure DCCP is disabled.	
#Ensure SCTP is disabled.	
#Ensure RDS is disabled.	
#Ensure TIPC is disabled.	


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




