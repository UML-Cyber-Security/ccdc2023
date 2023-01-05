#! /bin/bash    
apt-get -q install auditd audispd-plugins -y
systemctl --now enable auditd
touch /etc/audit/rules.d/ccdc.rules
chown root:root /etc/audit/rules.d/ccdc.rules

#git clone X
# mv X/Scripts/Linux/Installed-Services/Auditd/ccdc.rules /etc/audit/rules.d/ccdc.rules
echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules 

# rm -r X # At the end we do this 
