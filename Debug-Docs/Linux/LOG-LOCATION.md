# Basics
Where things are generally stored 


# Custom
## Sudo 
The SUDO script will chaneg the logging location for sudo actions to be stored at the following location
```
/var/log/sudo.log
```
If we do not use the sudo script the logs will be stored at the systems default logging equivalent of the following 
```
/var/log/syslog
```
## Iptables
Currently there is additional logging for SSH-INITAL connections,  INVALID packets (indicative of a scan), and ICMP-FLOOD packets (possible)

* SSH-INITAL will result in logs prefixed at log-level 5 (Notice) with 
  * "IPTables-SSH-INITIAL: "
* INVALID packets will result in logs prefixed at log-level 4 (Warning) with 
  * "IPTables-INVALID-LOG: "
* ICMP-FLOOD will result in logs prefixed at log-level 4 (warning) with
  * "IPTables-ICMP-FLOOD: " 
* Traffic to Docker containers will result in logs prefixed at log-level 5 (Notice) with
  * "IPTables-DOCKER-LOG:"

These are again stored in the systems default logging equivalent of the following 
```
/var/log/syslog
``` 

## Healthchecks
### Core Service
* "\[Health-Check-Docker:\]" - Indicates docker is not running
* "\[Health-Check-Auditd\]" - Indicates Auditd is not running
* "\[Health-Check-Glusterd\]" - Indicates Gluster is not running -- likely not needed.
*  "\[Health-Check-SSHD\]" - Indicates SSH server is not running -- bad...
*  "\[Health-Check-Cron\]" - Indicates Cron is not running
*   "\[Health-Check-Wazuh-Agent\]" - Indicates Wazuh is not running
*   "\[Health-Check-Rsyslog\]" - Indicates rsyslog is not running
*   "\[Health-Check-Auditd\]" - Indicates malformed auditd rules
    *   Need to change the value when deployed.
*   "\[Health-Check-sysctl\]" - Indicates malformed systemctl rule

These are again stored in the systems default logging equivalent of the following 
```
/var/log/syslog
``` 
## Auditd 
-- ref AUDITD section for manual overview

### Keys
* time-change
* system-locale
* MAC-policy
  * if apparmor is enabled
* logins
* session
* perm_mod
* access
* mounts
* delete
* scope
* sudo_log -- anything as root
* modules