
# This was in the other script forgot to move it over 
echo 'Defaults use_pty' | EDITOR="tee -a" visudo

# Change defualt log for SUDO -- can simplify auditing!
echo 'Defaults logfile="/var/log/sudo.log"' | EDITOR='tee -a' visudo
# Another thing, chaneg logs locations or sudo stuff --> good for soc.
