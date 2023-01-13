# What is checked 

* Docker
* Gluster
* SSHD
* AUDITD
  * number of rules
* CRON
* Sysctl
  * Set rules and values

There is a log-*.sh script which will log to the systems log file (syslog equivalent)

There is a echo-*.sh scrip which we can use to see if theses systems are running, or if the proper rules are configured.

## Cron Job
To schedule this we can use the provided setup-schedule script. This creates a cron job that will run every 5 minutes 