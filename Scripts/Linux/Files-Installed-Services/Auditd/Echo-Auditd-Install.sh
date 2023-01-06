#! /bin/bash
# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; 
    then apt-get -q install auditd audispd-plugins -y
    else yum install auditd audispd-plugins -y
fi

systemctl --now enable auditd
touch /etc/audit/rules.d/ccdc.rules
chown root:root /etc/audit/rules.d/ccdc.rules

# Log modifications to date and time. (2611)
echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change | -a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change | -a always,exit -F arch=b64 -S clock_settime -k time-change -a always,exit -F arch=b32 -S clock_settime -k time-change | -w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules 
# Log modifications to host/domain name (2613)
echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale   -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale       -w /etc/issue -p wa -k system-locale          -w /etc/issue.net -p wa -k system-locale           -w /etc/hosts -p wa -k system-locale         -w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 
# Log modifications to AppArmor's Mandatory Acces Controls (2614)
echo "-w /etc/apparmor/ -p wa -k MAC-policy | -w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/ccdc.rules 
# Collect login/logout information (2615)
echo "-w /var/log/faillog -p wa -k logins | -w /var/log/lastlog -p wa -k logins | -w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules
# Collect session initiation info (2616) 
echo "-w /var/run/utmp -p wa -k session | -w /var/log/wtmp -p wa -k logins | -w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules 
# Collect file permision changes (2617)
echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 
# Collect unsuccessful unauthorized file access attempts (2618)
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 
# Collect successful File system mounts (2619)
echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts | -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules 
# Collect file deletion events (2620)
echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete | -a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 
# Collect modifications to sudoers (2621)
echo "-w /etc/sudoers -p wa -k scope | -w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/rules.d/ccdc.rules 

############# 2622
# Collect kernel module loading/unloading (2623)
echo "-w /sbin/insmod -p x -k modules | -w /sbin/rmmod -p x -k modules | -w /sbin/modprobe -p x -k modules | -a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules
# Make audit logs immutable. (2624) 
echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules 
