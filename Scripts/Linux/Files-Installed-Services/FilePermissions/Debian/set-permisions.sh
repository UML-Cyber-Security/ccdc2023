
# Ownership of the message of the day
chown root:root /etc/motd

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


# Permissions for Message of the day
chmod u-x,go-wx /etc/motd 

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