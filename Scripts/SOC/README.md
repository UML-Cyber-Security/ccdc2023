# **Deploying SOC**

Follow the below mentioned steps to deploy Wazuh and Suricata on the remote machine.

Change to playbooks directory by using the below command

``` cd Baremetal_Install/playbooks ```

## **Deploying Wazuh**

We are going to deploy Wazuh on a single node initally and it can be done by running the foloowing command
``` ansible-playbook -vvv wazuh-single.yml ```

## **Deploying Suricata**

To deploy suricata and integrate it with Wazuh, run the below command

``` ansible-playbook -vvv suricata.yml ```

We are running the playbooks in verbose mode to be careful when deploying and it is easier to debug when in verbose mode.
