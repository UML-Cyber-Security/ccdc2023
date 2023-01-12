#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get -q install auditd audispd-plugins -y
elif [ -f "/etc/redhat-release" ]; then
    yum install auditd audit-libs -y
elif [ -f "/etc/arch-release" ];then 
    echo "Arch, Will this come up -- probably should do fedora"
fi

systemctl --now enable auditd
touch /etc/audit/rules.d/ccdc.rules
chown root:root /etc/audit/rules.d/ccdc.rules

# Log modifications to date and time. (2611)
# 32-64 bit
#echo -e "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change \n-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change \n-a always,exit -F arch=b64 -S clock_settime -k time-change \n-a always,exit -F arch=b32 -S clock_settime -k time-change \n-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time-change \n-a always,exit -F arch=b32 -S adjtimex,settimeofday,stime -k time-change \n-a always,exit -F arch=b64 -S clock_settime -k time-change \n-a always,exit -F arch=b32 -S clock_settime -k time-change \n-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules 

# Log modifications to host/domain name (2613)
#echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale   -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale       -w /etc/issue -p wa -k system-locale          -w /etc/issue.net -p wa -k system-locale           -w /etc/hosts -p wa -k system-locale         -w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale \n-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale \n-w /etc/issue -p wa -k system-locale \n-w /etc/issue.net -p wa -k system-locale \n-w /etc/hosts -p wa -k system-locale  \n-w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale \n-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale \n-w /etc/issue -p wa -k system-locale \n-w /etc/issue.net -p wa -k system-locale \n-w /etc/hosts -p wa -k system-locale  \n-w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 

if [ "$(systemctl status apparmor | grep "active (running)" | wc -l)" -ne 0 ]; then 
    # Log modifications to AppArmor's Mandatory Acces Controls (2614)
    #echo "-w /etc/apparmor/ -p wa -k MAC-policy -w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/ccdc.rules 
    echo -e "-w /etc/apparmor/ -p wa -k MAC-policy \n-w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/ccdc.rules 
fi
# Collect login/logout information (2615)
#echo "-w /var/log/faillog -p wa -k logins | -w /var/log/lastlog -p wa -k logins | -w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules
echo -e "-w /var/log/faillog -p wa -k logins \n-w /var/log/lastlog -p wa -k logins \n-w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules

# Collect session initiation info (2616) 
#echo "-w /var/run/utmp -p wa -k session | -w /var/log/wtmp -p wa -k logins | -w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-w /var/run/utmp -p wa -k session \n-w /var/log/wtmp -p wa -k logins \n-w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules 

# Collect file permision changes (2617)
#echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b64 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 

# Collect unsuccessful unauthorized file access attempts (2618)
#echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat -S open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b64 -S creat -S open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 

# Collect successful File system mounts (2619)
#echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts | -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts \n-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules 

# Collect file deletion events (2620)
#echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete | -a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete \n-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete \n-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 

# Collect modifications to sudoers (2621)
#echo "-w /etc/sudoers -p wa -k scope | -w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/rules.d/ccdc.rules 
echo -e "-w /etc/sudoers -p wa -k scope \n-w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/rules.d/ccdc.rules 

############# 2622

# Sudo log (all euid=0 from uid > 1000 that are not an unset uid.
# https://sudoedit.com/log-sudo-with-auditd/
echo -e "-a always,exit -F arch=b32 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log \n-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log" >> /etc/audit/rules.d/ccdc.rules

# Collect kernel module loading/unloading (2623)
#echo "-w /sbin/insmod -p x -k modules | -w /sbin/rmmod -p x -k modules | -w /sbin/modprobe -p x -k modules | -a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules
echo -e "-w /sbin/insmod -p x -k modules \n-w /sbin/rmmod -p x -k modules \n-w /sbin/modprobe -p x -k modules \n-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules



# Make audit logs immutable. (2624) -- ensure that this works 
echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules 

systemctl restart auditd
