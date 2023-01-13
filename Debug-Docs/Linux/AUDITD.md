# Auditd

We should not have to deal with this all that much but we can see if the rules failed to load by looking at two things.

```
auditctl -l
```
>This will list all of the applied rules

```
systemctl status auditd
```
>We can see if the daemon is active, and if the rule loading process failed 

We can restart the daemon with 
```sh
systemctl restart auditd

# or in the case of RHEL

service auditd restart 
```

There will be an attempt to load all files in the /etc/audit/rules.d directly ending in .rules. The format of the file is a newline separated list of valid Auditd rules to apply.

If we want to add an individual rule we can do 
```
auditctl -w <rule>
```

We can apparently use the following to generate a report.
```
aureport -n
```

# Ref
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-defining_audit_rules_and_controls
* https://wiki.archlinux.org/title/Audit_framework -- Recommended
* https://www.digitalocean.com/community/tutorials/how-to-use-the-linux-auditing-system-on-centos-7