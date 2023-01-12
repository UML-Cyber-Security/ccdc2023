# Based on WAZUH 
# If Debian
apt install libpam-pwquality

if [ "$(grep 'minlen' /etc/security/pwquality.conf) | wc -l)" -eq 0]
    echo "minlen = 14" >> /etc/security/pwquality.conf
else
    sed -i "s/.*minlen.*/minlen = 9/g" /etc/security/pwquality.conf
fi

# OR dcredit = -1 ucredit = -1 ocredit = -1 lcredit = -1 
if [ "$(grep 'minclass' /etc/security/pwquality.conf) | wc -l)" -eq 0]
    echo "minclass = 4" >> /etc/security/pwquality.conf
else
    sed -i "s/.*minclass.*/minclass = 4/g" /etc/security/pwquality.conf
fi

if [ "$(grep 'password requisite pam_pwquality.so' /etc/pam.d/common-password | wc -l)" -eq 0]
    echo "password requisite pam_pwquality.so retry 3" >> /etc/pam.d/common-password
else
    sed -i "s/password requisite pam_pwquality.so.*/password requisite pam_pwquality.so retry 3/g" /etc/pam.d/common-password
fi




if [ "$(grep 'auth required pam_tally2.so onerr' /etc/pam.d/common-auth) | wc -l)" -eq 0]
    echo "auth required pam_tally2.so onerr=fail" >> /etc/pam.d/common-auth
else
    sed  -i "s/.*auth required pam_tally2.so onerr.*/auth required pam_tally2.so onerr=fail/g" /etc/pam.d/common-auth
fi

if [ "$(grep 'audit silent deny' /etc/pam.d/common-auth) | wc -l)" -eq 0]
    echo "audit silent deny=5" >> /etc/pam.d/common-auth
else
    sed  -i "s/.*audit silent deny.*/audit silent deny=5/g" /etc/pam.d/common-auth
fi

# If the user fails to loging N times then they are locked out for 900 seconds
if [ "$(grep 'unlock_time' /etc/pam.d/common-auth) | wc -l)" -eq 0]
    echo "unlock_time=900" >> /etc/pam.d/common-auth
else
    sed  -i "s/.*unlock_time.*/unlock_time=900/g" /etc/pam.d/common-auth
fi

if [ "$(grep 'account\s*requisite' /etc/pam.d/common-account) | wc -l)" -eq 0]
    echo "account     requisite    pam_deny.so" >> /etc/pam.d/common-account
else
    sed  -i "s/.*account\s*requisite.*/account     requisite    pam_deny.so/g" /etc/pam.d/common-account
fi

# Lock user accounts after certain number of failed ssh login attempts
# https://www.tecmint.com/use-pam_tally2-to-lock-and-unlock-ssh-failed-login-attempts/
if [ "$(grep 'account\s*required' /etc/pam.d/common-account) | wc -l)" -eq 0]
    echo "account     required    pam_tally2.so" >> /etc/pam.d/common-account
else
    sed  -i "s/.*account\s*required.*/account     required    pam_tally2.so/g" /etc/pam.d/common-account
fi

# Remember the previous 5 passwords (prevents reuse) 
if [ "$(grep 'password\s*required\s*pam_pwhistory.so' /etc/pam.d/common-password ) | wc -l)" -eq 0]
    echo "password required pam_pwhistory.so remember=5" >> /etc/pam.d/common-password
else
    sed  -i "s/.*password\s*required\s*pam_pwhistory.so.*/password required pam_pwhistory.so remember=5/g" /etc/pam.d/common-password
fi

# User SHA512 Hash insted of defualt MD5
# Need to reset all prexisting passwords (RUN PASSWD CHANGE AFTER THIS 
if [ "$(grep 'password [success=1 default=ignore] pam_unix.so sha512' /etc/pam.d/common-password ) | wc -l)" -eq 0]
    echo "password [success=1 default=ignore] pam_unix.so sha512" >> /etc/pam.d/common-password
else
    sed  -i "s/.*password\s*[success=1 default=ignore]\s*pam_unix.so.*/password [success=1 default=ignore] pam_unix.so sha512/g" /etc/pam.d/common-password
fi

#Set the PASS_MIN_DAYS parameter to 1 in /etc/login.defs : PASS_MIN_DAYS 1 Modify user parameters for all users with a password set to match: # chage --mindays 1 <user>
#Set the PASS_MAX_DAYS parameter to conform to site policy in /etc/login.defs : PASS_MAX_DAYS 365 Modify user parameters for all users with a password set to match: # chage --maxdays 365 <user>
#Set the PASS_WARN_AGE parameter to 7 in /etc/login.defs: PASS_WARN_AGE 7. Modify user parameters for all users with a password set to match: # chage --warndays 7 <user>. Notes: You can also check this setting in /etc/shadow directly. The 6th field should be 7 or more for all users with a password.
#Run the following command to set the default password inactivity period to 30 days: # useradd -D -f 30. Modify user parameters for all users with a password set to match: # chage --inactive 30 <user>. Notes: You can also check this setting in /etc/shadow directly. The 7th field should be 30 or less for all users with a password. A value of -1 would disable this setting.
