# TODO 
1. SSH CONFIG
   1. Would we like MFA too? That seems fun
   2. Install Pull SSH
2. PAM CONFIG
   1. What do we want with this
3. Create a "super-Script" to manage the individual deployment 

# NOTICE
Auditd should be configured LAST otherwise we will generate a large amount of noise.

# Installed Services
* sudo
* auditd
  * Configured using ECHOS 
  * Configured pulling and moving document
* ufw
  * Need to look into if this is needed 
* ldap-utils (OPTION 1 = 1 install or 0 Dont) for 


# Removed 
* autofs
* telnet
* nis
* talk
* rsh-client
# Install-Pull-Move
Installs or Enables all services, pulls predone file from git repository moves into place

Auditd (Not arguments passed) makes all files and echos in or pulls from repository


# Questions 
systemctl --now disable rsync #rsync is considered insecure
systemctl --now disable nis # to quote wazuh "NIS is inherently an insecure system"
> If we purge it what does this do?

