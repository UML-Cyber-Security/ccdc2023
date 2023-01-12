#! /bin/bash
# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Remove deny file 
rm /etc/at.deny 
rm /etc/cron.deny
touch /etc/cron.allow
touch /etc/at.allow
# ADD ADMIN TO ALLOW LIST
# For Both Cron and AT
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow

# https://www.cyberciti.biz/faq/howto-linux-unix-start-restart-cron/
if [ -f redhat-release ] | [ -f /etc/alpine-release ] ; then 
  systemctl --now enable crond 
else
  systemctl --now enable cron
fi
  