#! /bin/bash
# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Remove deny file 
rm /etc/at.deny # Remove deny list for at commands?, why not add all users except for the root and Admin?
rm /etc/cron.deny
touch /etc/cron.allow
touch /etc/at.allow
# ADD ADMIN TO ALLOW LIST
# For Both Cron and AT
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow