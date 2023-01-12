# Auditd
The Auditd scrip will install start and enable the Auditd service. 

The rules are created in **/etc/audit/rules.d/ccdc.rules**

The value of 2 is written to **/etc/audit/rules.d/99-finalize.rules** to finalize the rules so no changes can be made

We restart the Auditd service to apply the rules


We set rules to:
* Make audit logs immutable. (2624)
* Collect kernel module loading/unloading (2623)
* Collect modifications to sudoers (2621)
* Collect file deletion events (2620)
* Collect successful File system mounts (2619)
* Collect unsuccessful unauthorized file access attempts (2618)
* Collect file permision changes (2617)
* Collect session initiation info (2616)
* Collect login/logout information (2615) 
* Log modifications to AppArmor's Mandatory Acces Controls (2614)
* Log modifications to host/domain name (2613)
* Log modifications to date and time. (2611)

# Rsyslog 
The Rsyslog script installs rsyslog. It sets the FileCreateMode to 0640.