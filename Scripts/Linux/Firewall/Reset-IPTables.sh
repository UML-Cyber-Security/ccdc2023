#! /bin/bash
# Resets IPTables. Undoes work done by the Firewall-IPTables script

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
# Policies 
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

ip6tables -P INPUT ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -P FORWARD ACCEPT

# Flush 
iptables -F INPUT
iptables -F OUTPUT
iptables -F DOCKER-USER
iptables -t mangle -F PREROUTING

iptables -F DOCKER-LOG
iptables -F SSH-INITIAL-LOG
iptables -t mangle -F INVALID-LOG

# Remove User Chains 
iptables -X DOCKER-LOG
iptables -X SSH-INITIAL-LOG
iptables -t mangle -X INVALID-LOG



