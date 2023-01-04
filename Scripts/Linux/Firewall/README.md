# IPTables (IPv4)
## Logging
Currently there is additional logging for SSH-INITAL connections and INVALID packets (indicative of a scan)

## INPUT Chain
allow source port connections of 80 and 443 to allow web responces? Rather then (allow established?)
### HTTPS
```
### HTTPS -- needed for all?
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

### ICMP
Ping is not automatically enabled. 
``` sh
# Ping rules
iptables -A INPUT -m conntrack -p icmp --icmp-type 0 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m conntrack -p icmp --icmp-type 8 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
```

### Established.
Established is automatically enabled. 
```
# Allows incoming connections from established outbound connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```


## Outbound 
Allowing all ICMP for now. We can limit a little later.
Check and go over other capablities we want or need

# IP6Tables (IPv6)
Currently I Just set the default policies to drop, is IPv6 necessary?
Otherwise we will just have to copy the IPv4 commands to IPv6 and change some of the ICMP Allows.

# Notes 
VSCode connections work with the current setup so Justin may be happy
