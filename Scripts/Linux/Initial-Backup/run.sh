#! /bin/bash
# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Make central location for backup files
mkdir /backups

# Change ownership of the directory to root
chown root:root /backups
# Make it read-write for root but no others
chmod 600 /backups

echo "[+] Backing up old Bash to ~/copied-bash-history"

# Get all home directoriers where histories may be stored
UserHome="$(ls /home)"

# Loop through all users with home dirs, copy bash or zsh file.. May want to scan for all history types
for user in $UserHome
do
    result=$user"Primary-History"
    if [ "$(awk -F':' '/bash/ { print $1}' /etc/passwd | grep $user | wc -l)" -eq 1 ];
    then cp /home/$user/.bash_history /backups/$result
    else if [ "$(awk -F':' '/zsh/ { print $1}' /etc/passwd | grep $user | wc -l)" -eq 1 ];
    then cp /home/$user/.zsh_history /backups/$result
    #else if 
    #else
    fi
done

echo "[+] Backing up old config to /etc/ssh/sshd_config.backup"
cp /etc/ssh/sshd_config /backup/sshd_config.backup

# Tell me what else!