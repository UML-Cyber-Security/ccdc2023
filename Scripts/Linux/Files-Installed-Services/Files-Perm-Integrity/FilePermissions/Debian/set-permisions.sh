#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ownership of the message of the day and related files
chown root:root /etc/motd  
chown root:root /etc/issue 
chown root:root /etc/issue.net 

# Ownership of Password related Files
# User:Group
chown root:root /etc/group
chown root:shadow /etc/gshadow
chown root:root /etc/passwd
chown root:shadow /etc/shadow
chown root:root /etc/passwd-
chown root:shadow /etc/gshadow-
chown root:root /etc/group-
chown root:shadow /etc/shadow-

# Change Ownership of Chron Files
chown root:root /etc/crontab
chown root:root /etc/cron.hourly
chown root:root /etc/cron.daily
chown root:root /etc/cron.weekly
chown root:root /etc/cron.monthly

# SSHD config ownership
chown root:root /etc/ssh/sshd_config 
# SSH Private key ownership
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
# SSH Public Keys ownership
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;




# Permissions for Message of the day and related files
chmod u-x,go-wx /etc/motd
chmod u-x,go-wx /etc/issue
chmod u-x,go-wx /etc/issue.net

# Permissions for Password related Files
chmod 644 /etc/group
chmod 644 /etc/passwd
chmod o-rwx,g-wx /etc/gshadow
chmod o-rwx,g-wx /etc/shadow
chmod 644 /etc/group-
chmod 644 /etc/passwd-
chmod o-rwx,g-wx /etc/gshadow-
chmod o-rwx,g-wx /etc/shadow-

# Permissions for Chron files
chmod og-rwx /etc/crontab
chmod og-rwx /etc/cron.hourly
chmod og-rwx /etc/cron.daily
chmod og-rwx /etc/cron.weekly
chmod og-rwx /etc/cron.monthly

#SSHD permissions 
chmod og-rwx /etc/ssh/sshd_config
# SSH Private key permissions 
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;
# SSH Public Keys permissions
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 0644 {} \; 


# Chnage permissions of all files in /var/log
# find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +#