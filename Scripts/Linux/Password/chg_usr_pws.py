#! /bin/bash

from os import system
from random import choices
import string

usr_accts, ref = [], ["bash", "sh", "zsh"]

root_pw = '1qazxsW@1' #nothing to see here

def run():
    #Get user accts
    with open("/etc/passwd") as uLog:
        usrs = uLog.readlines()
        for usr in usrs:
            if any(r in usr for r in ref):
                usr_accts.append(usr.rstrip().split(":")[0])
                
    #Set new passwords 
    with open("usr_pw_prs.txt", "w") as pLog:           
        for usr in usr_accts:
            if usr == 'root':
                pr = (usr, root_pw)
            else:
                pr = (usr, ''.join((choices(string.ascii_lowercase, k=9))))
            system(f'echo "{pr[0]}:{pr[1]}" | sudo chpasswd')
            pLog.write(str(pr) + "\n")


if __name__ == "__main__":
    run()
