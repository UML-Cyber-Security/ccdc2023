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

#The Datagram Congestion Control Protocol (DCCP) is a transport layer protocol that supports streaming media and telephony. 
# DCCP provides a way to gain access to congestion control, without having to do it at the application layer, 
#but does not provide in- sequence delivery.
# If the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.
touch /etc/modprobe.d/dccp.conf # Need to check if it is required.
echo "install dccp /bin/true" > /etc/modprobe.d/dccp.conf 

# The Stream Control Transmission Protocol (SCTP) is a transport layer protocol used to support message oriented communication, with several streams of messages in one connection. It serves a similar function as TCP and UDP, incorporating features of both. It is message-oriented like UDP, and ensures reliable in-sequence transport of messages with congestion control like TCP.
#If the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.
touch /etc/modprobe.d/sctp.conf # Need to check if it is required.
echo "install sctp /bin/true" >> /etc/modprobe.d/sctp.conf 

# The Reliable Datagram Sockets (RDS) protocol is a transport layer protocol designed to provide low-latency, high-bandwidth communications between cluster nodes. It was developed by the Oracle Corporation.
#If the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.
touch /etc/modprobe.d/rds.conf # Need to check if it is required.
echo "install rds /bin/true" >> /etc/modprobe.d/rds.conf

# The Transparent Inter-Process Communication (TIPC) protocol is designed to provide communication between cluster nodes.
# Again if not needed disable 
touch /etc/modprobe.d/tipc.conf # Need to check if it is required.
echo "install tipc /bin/true" >> /etc/modprobe.d/rds.conf

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
if [ "$(grep 'End of file' /etc/security/limits.conf | wc -l)" -ne 0]; then
  sed -i 's/\(.* End of file\)/* hard core 0\n\1/g' /etc/security/limits.conf
else 
  echo "hard core 0\n# End of file" >> /etc/security/limits.conf
fi
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
if [ "$(grep 'GRUB_CMDLINE_LINUX=.*' | wc -l)" -ne 0 ]; then
  sed "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"ipv6.disable=1\"/g"  /etc/default/grub
else
  echo "GRUB_CMDLINE_LINUX=\"ipv6.disable=1\"" >> /etc/default/grub
fi
update-grub

#Edit /etc/exim4/update-exim4.conf and and or modify following lines to look like the lines below: dc_eximconfig_configtype='local' dc_local_interfaces='127.0.0.1 ; ::1' dc_readhost='' dc_relay_domains='' dc_minimaldns='false' dc_relay_nets='' dc_smarthost='' dc_use_split_config='false' dc_hide_mailname='' dc_mailname_in_oh='true' dc_localdelivery='mail_spool' Restart exim4: # systemctl restart exim4


# Disable wireless interfaces 
# nmcli radio all off # Not needed 

# Sysctl
## May break systems >> refer to this for simplified docker wokeing one https://bugs.launchpad.net/ubuntu/+source/procps/+bug/1676540

# Prevent ICMP IPv4 Redirects (Use when a system is not acting as a router)
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/ccdc.conf 


# Run the following command to restore the default parameter and set the active kernel parameter: # grep -Els "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.ip_forward\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv4.ip_forward=0; sysctl -w net.ipv4.route.flush=1 IF IPv6 is enabled: Run the following command to restore the default parameter and set the active kernel parameter: # grep -Els "^\s*net\.ipv6\.conf\.all\.forwarding\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv6\.conf\.all\.forwarding\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv6.conf.all.forwarding=0; sysctl -w net.ipv6.route.flush=1
 
# In networking, source routing allows a sender to partially or fully specify the route packets take through a network. 
# In contrast, non-source routed packets travel a path determined by routers in the network. In some cases, 
# systems may not be routable or reachable from some locations (e.g. private addresses vs. Internet routable), 
# and so source routed packets would need to be used.
###### Disable source routing 
echo "net.ipv4.conf.all.accept_source_route = 0">> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.accept_source_route = 0 " >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv6.conf.all.accept_source_route = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.d/ccdc.conf 
# Load conf values refresh 
sysctl -w net.ipv6.route.flush=1


# ICMP redirect messages are packets that convey routing information and tell your host (acting as a router) to send packets 
# via an alternate path. It is a way of allowing an outside routing device to update your system routing tables. By setting 
# net.ipv4.conf.all.accept_redirects and net.ipv6.conf.all.accept_redirects to 0, the system will not accept any ICMP redirect 
# messages, and therefore, won't allow outsiders to update the system's routing tables.

# Disable IPv4 redirects
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
# IPv6 Redirects 
echo "net.ipv6.conf.all.accept_redirects = 0"  >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv6.conf.default.accept_redirects = 0"  >> /etc/sysctl.d/ccdc.conf 
# Load conf values refresh 
sysctl -w net.ipv6.route.flush=1

# Disable secure redirects, same as normal redirects but from known gateways
echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
# Load Conf values sysctl -p // --> see sysctl-AA.sh
sysctl -w net.ipv4.route.flush=1

# Log packets with unroutable destinations
echo "net.ipv4.conf.all.log_martians = 1 " >> /etc/sysctl.d/ccdc.conf # -- Done in script
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.d/ccdc.conf 
# Load conf
sysctl -w net.ipv4.route.flush=1

# Ignore all echo and timestamp broadcast requests 
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
# Load conf
sysctl -w net.ipv4.route.flush=1

# Prevent kernel from logging bogus responces
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
# Load conf
sysctl -w net.ipv4.route.flush=1

# forces the Linux kernel to utilize reverse path filtering on a received packet to determine if the packet was valid.
# Essentially, with reverse path filtering, if the return packet does not go out the same interface that the corresponding 
# source packet came from, the packet is dropped (and logged if log_martians is set).
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
# Load congig
sysctl -w net.ipv4.route.flush=1

# Prevent Syn Flooding
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/ccdc.conf
# Load conf
sysctl -w net.ipv4.route.flush=1

# IF IPv6 is enabled disable the system's ability to accept IPv6 router advertisements.
#It is recommended that systems do not accept router advertisements as they could be tricked into routing traffic to compromised machines. Setting hard routes within the system (usually a single default route to a trusted router) protects the system from bad routes.
echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.d/ccdc.conf #--> May not recomend, but most traffic will be over IPv4 so this may be good? O.W IPv6 router needs to be hard set
echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.d/ccdc.conf
# Load config
sysctl -w net.ipv6.route.flush=1

# This was in the other script forgot to move it over 
echo 'Defaults use_pty' | sudo EDITOR="tee -a" visudo

# Change defualt log for SUDO -- can simplify auditing!
echo 'Defaults logfile="/var/log/sudo.log"' | sudo EDITOR='tee -a' visudo
# Another thing, chaneg logs locations or sudo stuff --> good for soc.


# SSHD config  perms and ownership
chown root:root /etc/ssh/sshd_config 
chmod og-rwx /etc/ssh/sshd_config

# SSH Private key ownership and permissions 
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;

# SSH Public Keys ownership and permissions
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 0644 {} \; 
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

# Set log level to verbose 
if [ "$(grep 'LogLevel' /etc/ssh/sshd_config | wc -l)" -ne 0 ]; then
  sed -i 's/.*\(LogLevel\).*/\1 VERBOSE/g' /etc/ssh/sshd_config
else
  echo "LogLevel=VERBOSE" >> /etc/ssh/sshd_config
fi
# Banner to Display
if [ "$(grep 'Banner' /etc/ssh/sshd_config | wc -l)" -ne 0 ]; then
  sed "s|.*Banner.*|Banner /etc/issue.net|g" /etc/ssh/sshd_config
else 
  echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
fi

# Root Group
usermod -g 0 root

################################# Auditd 
# Reloading the auditd config to set active settings may require a system reboot.
# Record events affecting the group , passwd (user IDs), shadow and gshadow (passwords) or /etc/security/opasswd
# The parameters in this section will watch the files to see if they have been opened for write or have had attribute
# changes (e.g. permissions) and tag them with the identifier "identity" in the audit log file.
echo " -w /etc/group -p wa -k identity | -w /etc/passwd -p wa -k identity | -w /etc/gshadow -p wa -k identity | -w /etc/shadow -p wa -k identity | -w /etc/security/opasswd -p wa -k identity" >> /etc/audit/rules.d/ccdc.rules

# Record changes to network environment files or system calls. Sethostname or setdomainnam system calls
echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale -w /etc/issue -p wa -k system-locale -w /etc/issue.net -p wa -k system-locale -w /etc/hosts -p wa -k system-locale -w /etc/network -p wa -k system-locale | -a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale -w /etc/issue -p wa -k system-locale -w /etc/issue.net -p wa -k system-locale -w /etc/hosts -p wa -k system-locale -w /etc/network -p wa -k system-locale." >> /etc/audit/rules.d/ccdc.rules

# Sudo log (all euid=0 from uid > 1000 that are not an unset uid.
# https://sudoedit.com/log-sudo-with-auditd/
echo "-a always,exit -F arch=b32 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log | -a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log" >> /etc/audit/rules.d/ccdc.rules



################################## Journald
# Ensure Journald logs are sent to syslog
if [ "$(grep "ForwardToSyslog" /etc/systemd/journald.conf | wc -l)" -ne 0 ]; then 
  sed -i 's/.*ForwardToSyslog.*/ForwardToSyslog=yes/g' /etc/systemd/journald.conf
else
  echo "ForwardToSyslog=yes" >> /etc/systemd/journald.conf
fi

# Compress large log files
if [ "$(grep "Compress" /etc/systemd/journald.conf | wc -l)" -ne 0 ]
  sed -i 's/.*Compress.*/Compress=yes/g' /etc/systemd/journald.conf
else
  echo "Compress=yes" >> /etc/systemd/journald.conf
fi

# Logs written to disk rather than stored in volitile mem (RAM?)
if [ "$(grep "Storage" /etc/systemd/journald.conf | wc -l)" -ne 0 ]
  sed -i 's/.*Storage.*/Storage=persistent/g' /etc/systemd/journald.conf
else
  echo "Storage=persistent" >> /etc/systemd/journald.conf
fi

# Change Lof file perms
# For all files and directories in /var/log execute chmod --- on what was found
find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +


#If any accounts in the /etc/shadow file do not have a password, run the following command to lock the account until it can be determined why it does not have a password: # passwd -l <em><username></em>. Also, check to see if the account is logged in and investigate what it is being used for to determine if it needs to be forced off.



# Single User Mode --> Look this up why did I do this, is it useful?
sed -i "s|ExecStart.*|ExecStart=-/bin/sh -c '/sbin/sulogin; /usr/bin/systemctl --fail --no-block default'|g" /usr/lib/systemd/system/rescue.service
sed -i "s|ExecStart.*|ExecStart=-/bin/sh -c '/sbin/sulogin; /usr/bin/systemctl --fail --no-block default'|g" /usr/lib/systemd/system/emergency.service
#<< They just want us to set a password on the root account...>>



#Run the following command to restore binaries to normal: # prelink -ua Uninstall prelink using the appropriate package manager or manual installation: # apt purge prelink	prelink is a program that modifies ELF shared libraries and ELF dynamically linked binaries in such a way that the time needed for the dynamic linker to perform relocations at startup significantly decreases.




# Security Update 
apt -s upgrade

# Time Synchronization NTP Install ntp or chrony
if [ "$(systemctl is-enabled systemd-timesyncd)" != "disabled" ]; then
    apt install chrony # Need to configure files and everything
    timedatectl set-ntp on
fi


#Disable IPv6.




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
#Ensure journald is configured to send logs to rsyslog.	-
#Ensure journald is configured to compress large log files.	-
#Ensure journald is configured to write logfiles to persistent disk.	-


# perm Log-- need to check
#Ensure permissions on all logfiles are configured.	find /var/log -type f -ls

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

# Password This
Ensure password fields are not empty.	-
Ensure root is the only UID 0 account.	-
Ensure shadow group is empty.	 sh -c "awk -F: -v GID=\"$(awk -F: '($1==\"shadow\") {print $3}' /etc/group)\" '($4==GID) {print $1}' /etc/passwd"




