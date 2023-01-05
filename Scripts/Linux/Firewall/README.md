# TODO
* Gluster (May be a manual process)
  * https://docs.gluster.org/en/main/Install-Guide/Configure/
  * That or know all the ports that will be used and free those.
    * https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#installing-the-gluster-native-client
    * sudo iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 24007:24008 -j ACCEPT
    * sudo iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 49152:49156 -j ACCEPT\
    * Script to add and setup additional blocking rules based on known paramiters (Subnet range)

* Check if UFW appends or inserts 
  * Depending on this people can use UFW more than IPTables
* Simplify rules using modules like -- multiport 
  * Specify range of --dport with 1:10 [1,10]


# IPTables (IPv4)
## Logging
Currently there is additional logging for SSH-INITAL connections,  INVALID packets (indicative of a scan), and ICMP-FLOOD packets (possible)

* SSH-INITAL will result in logs prefixed at log-level 5 (Notice) with 
  * "IPTables-SSH-INITIAL: "
* INVALID packets will result in logs prefixed at log-level 4 (Warning) with 
  * "IPTables-INVALID-LOG: "
* ICMP-FLOOD will result in logs prefixed at log log-level 4 (warning) with
  * "IPTables-ICMP-FLOOD: " 

## Gluster
A Gluster Chain (GLUSTER) is created with the necissary rules to support 10 blocks on a system. (Arbitrarily Chosen)
We can enable the Gluster rules by adding the chain to the INPUT and OUTPUT chains.

We provide no conditions as this is just a patchwork rule, so this will exist on all systems and can be enabled with 2 lines.
```sh
# Add Gluster to the system
iptables -j GLUSTER
ip6tables -j GLUSTER
```

Note: It will be necessary to limit the range to that which is provided.
> Gluster-10 onwards, the brick ports will be randomized. A port is randomly selected within the range of base_port to max_port as defined in glusterd.vol file and then assigned to the brick. For example: if you have five bricks, you need to have at least 5 ports open within the given range of base_port and max_port. To reduce the number of open ports (for best security practices), one can lower the max_port value in the glusterd.vol file and restart glusterd to get it into effect.

Not that the other alternative is we accept all traffic from a source address. As currently we accept all traffic to and from a Gluster port.

## INPUT Chain
allow source port connections of 80 and 443 to allow web responces? Rather then (allow established?)
### HTTPS
```
### HTTPS -- needed for all?
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```
### DNS
Currenly we only allow DNS(53) traffic over UDP for Name resolution. We may need to enable DNS over TCP if we need to allow for Zone Transfers.
```sh
# DNS Zone Transfers
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
```

### ICMP
Ping is automatically allowed. Comment out the following in the scrip to remove this.
``` sh
# Ping rules
iptables -A INPUT -m conntrack -p icmp --icmp-type 0 --ctstate NEW,ESTABLISHED,RELATED -j ICMP-FLOOD
iptables -A INPUT -m conntrack -p icmp --icmp-type 8 --ctstate NEW,ESTABLISHED,RELATED -j ICMP-FLOOD
```

IPv6 needs a large number of ICMPv6 packets enabled to function properly.

### Established.
Established connections are automatically allowed. Comment the following in the script to remove it 
```
# Allows incoming connections from established outbound connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```


## Outbound 
Allowing all ICMP for now. We can limit a little later.
Check and go over other capabilities we want or need

# Notes 
VSCode connections work with the current setup so Justin may be happy
