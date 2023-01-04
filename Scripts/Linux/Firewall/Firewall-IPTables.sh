#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Get distribution, read 5th line from /etc/...-release
DISTRO=$(sed -n '5p' /etc/*-release)

# Simple check to see if firewalld is installed and running
FIREWALLD=$(service firewalld status)

# Check OS (RHEL may use firewalld) -- Placeholder
#if [[ ("$DISTRO" != "NAME=\"Ubuntu\"") || ("$FIREWALLD" == "firewalld: unrecognized service") ]]; then
  #  echo "Manual Intervention Required"
 #   exit
#fi



# The following will be IPTable Commands

# -------------------------------------- Reset Chains chain ---------------------------------------------------------
# Flush the Input and Output chains
iptables -t filter -F INPUT
iptables -t filter -F OUTPUT
# -------------------------------------------------------------------------------------------------------------------

# -------------------------------------- Create LOGGING chains ------------------------------------------------------

# Make Logging Chains (General)
# In filter table
iptables -N SSH-INITIAL-LOG
# In mangle table
iptables -t mangle -N INVALID-LOG
# Make Drop Packet Chain
# iptables -N DROP-LOG
# -------------------------------------------------------------------------------------------------------------------


# -------------------------------------- Setup SSH-INITIAL-LOG chain ---------------------------------------------------------
# Use the limit module to limit the number of logs made
# Prefix with IPTables-SSH-INITIAL:
# Give it a log level of 5 (Notification) 
iptables -A SSH-INITIAL-LOG -m limit --limit 4/sec -j LOG --log-prefix "IPTables-SSH-INITIAL: " --log-level 5
iptables -A SSH-INITIAL-LOG -j RETURN 
# ----------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------ INVALID-LOG chain ---------------------------------------------------------
# Use the limit module to limit the number of logs made
# Prefix with IPTables-SSH-INITIAL:
# Give it a log level of 4 (Warning) 
# Drop the invalid packets
iptables -t mangle -A INVALID-LOG -m limit --limit 5/sec -j LOG --log-prefix "IPTables-INVALID-LOG: " --log-level 4
iptables -t mangle -A INVALID-LOG -j DROP 
# ----------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------ MANGLE tb, PREROUTING chain -----------------------------------------------
# Block all packets with syn set that are not new TCP messages (WINDOW SCAN)
iptables -t mangle -I PREROUTING -m conntrack -p tcp ! --syn --ctstate NEW -j INVALID-LOG
# Blocks all invlaid connections (XMAS SCAN)
iptables -t mangle -I PREROUTING -m conntrack --ctstate INVALID -j INVALID-LOG
# ----------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------ INPUT chain ---------------------------------------------------------------
### SSH
# Log any SSH connection attempt
iptables -I INPUT -m conntrack -p tcp --dport 22 --ctstate NEW -j SSH-INITIAL-LOG
# Accept SSH Connections
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

### DNS
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

### Loop back interface (sudo and other things may be slow otherwise)
iptables -A INPUT -i lo -j ACCEPT

### HTTPS -- needed for all? --- 
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

### ICMP Packets
# Accept ICMP packets of type 3 - unreachable destination (NEW ESTB and RELATED conns)
iptables -A INPUT -m conntrack -p icmp --icmp-type 3 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
# Accept ICMP packets of type 11 - Time exceded (TTL expired) (NEW ESTB and RELATED conns)
iptables -A INPUT -m conntrack -p icmp --icmp-type 11 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
# Accept ICMP packets of type 12 - Bad IPheader packet (NEW ESTB and RELATED conns)
iptables -A INPUT -m conntrack -p icmp --icmp-type 12 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

# Ping rules
# iptables -A INPUT -m conntrack -p icmp --icmp-type 0 --ctstate NEW,ETABLISHED,RELATED -j ACCEPT
# iptables -A INPUT -m conntrack -p icmp --icmp-type 8 --ctstate NEW,ETABLISHED,RELATED -j ACCEPT

### INBOUND
# Allows incoming connections from established outbound connections -- Do we want this
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# ----------------------------------------------------------------------------------------------------------------------------


# ----------------------------------------------- OUTPUT chain ---------------------------------------------------------------
# SSH
# Log any SSH connection attempt, this is here because it would be odd to do something like this in an outgoing connection
iptables -I OUTPUT -m conntrack -p tcp --dport 22 --ctstate NEW -j SSH-INITIAL-LOG
# Accept SSH Connections
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT 

### DNS
# Allow Outbound DNS
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
# Allow DNS responces 
iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT


### Loop back interface (sudo and other things may be slow otherwise)
iptables -A OUTPUT -o lo -j ACCEPT

### HTTP/ HTTPS
# Allow requests 
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
# Allow responses 
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT


# Wahzu 
iptables -A OUTPUT -p tcp --sport 1514 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 1514 -j ACCEPT

# For Now Just allow outbound ICMP 
iptables -A OUTPUT -p icmp -j ACCEPT
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------- POLICIES  ------------------------------------------------------------------
# Set defualt policy of All FILTER chains to DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------- Docker Specific IPTables rules  --------------------------------------------
if ! [[ -x "$(command -v docker)" ]]; then
    echo "Docker is not installed, exiting script!"
    exit
fi
# Create Docker Chain
iptables -N DOCKER-LOG

# Set log for all docker traffic 
# use limit module to limit logs generated to 3 packets a second
# Log with prefix "IPTables-DOCKER-LOG:"
# Set log level to 5 (Notification)
iptables -I DOCKER-LOG -m limit --limit 3/sec -j LOG --log-prefix "IPTables-DOCKER-LOG:" --log-level 5
# Return
iptables -A DOCKER-LOG -j RETURN


# Create rule to log (traffic to container)
# only logs traffic being forwarded to the container
# To limit the amount of logs generated we can limit it to new connections
iptables -I DOCKER-USER  -o docker0 -j DOCKER-LOG
# ----------------------------------------------------------------------------------------------------------------------------



################################## IPv6 #########################################

# Set policies for now
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

