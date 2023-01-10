#!/bin/bash
if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

PORTNUM="8808"

# SSHD will bind to port 8808 rather than 22.
if [ "$(grep '.*Port' /etc/ssh/sshd_config | wc -l )" -eq 0 ]; then 
    echo "Port $PORTNUM" >> /etc/ssh/sshd_config
else
    # If we do find an entry, we can remove it
    # And replace it with port X
    sed -i "s/^\(.Port.*\)/Port $PORTNUM/g" /etc/ssh/sshd_config
fi

echo "[!!] Removing old SSH rules"

# Old method
#INPUTSSH="$(iptables -nv -L INPUT --line-number | grep "22" | awk -F " " '{print $1 }')"
# awk can do regex evlauation, $0 refers to the input line "~" is the regex operator, 
# and -v sets a varable re we can refer to
INPUTSSH="$(iptables -nv -L INPUT --line-number | awk -v re="22" -F " " '$0 ~ re {print $1 }')"
# Iterate and remove

# Replace with basic rules (SSHLOG -> accep)
OUTPUTSSH="$(iptables -nv -L OUTPUT --line-number | awk -v re="22" -F " " '$0 ~ re {print $1 }')"
# Iterate and remove 
# Repace with allow. outbouand (To PORT /from out PORT)
#FORWARDSSH="$(iptables -nv -L FORWARD --line-number | awk -v re="22" -F " " '$0 ~ re {print $1 }')"
# Iterate and remove