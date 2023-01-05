# Central Location
echo "[+] Backing up old Bash to ~/copied-bash-history"
history > ~/copied-bash-history

echo "[+] Backing up old config to /etc/ssh/sshd_config.backup"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup