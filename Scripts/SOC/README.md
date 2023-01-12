# **Deploying SOC**

## **Pre-Requisites**

Change to playbooks directory by using the below command

``` cd Baremetal_Install/playbooks ```

- The playbooks are designed to run the tasks on various remote machines running different operating systems
- Ensure that the ***inventory***  file has the IP addresses of the remote hosts as below

```
[SOC_Server]
192.168.0.121

[Debian_Agents]
192.168.0.66

[Windows_Agents]

[CentOS_Agents]
```

Follow the below mentioned steps to deploy Wazuh and Suricata on the remote machine.

## **Deploying Wazuh**

We are going to deploy Wazuh on a single node initally and it can be done by running the following command

``` ansible-playbook -vvv wazuh-single.yml ```

## **Deploying Suricata**

To deploy suricata and integrate it with Wazuh, run the below command. This will also integrate docker logs into Wazuh.

``` ansible-playbook -vvv suricata.yml ```

We are running the playbooks in verbose mode to be careful when deploying and it is easier to debug when in verbose mode.

## **Enabling Debian Agents to send Docker logs to the server**

To enable the Debian Agents to send docker logs to the wazuh server, run the following command

``` ansible-playbook docker _agent.yml ```

## **Enabling CentOS Agents to send Docker logs to the server**

To enable the CentOS Agents to send docker logs to the wazuh server, run the following command

``` ansible-playbook docker-agent.yml -i CentOS_Agents ```

## **Using tags to restart services**

To restart Wazuh and Suricata use the following command

``` ansible-playbook suricata.yml --tags restart_services ```

## **Adding Debian agents**

- The SOC team will give you a command to be run on the Debain agents. Replace the command in *add_agent_debian.sh* with the command the SOC team has given you and then run the following command to add debian machines as an agent

``` ansible-playbook -vvv add_agent_debian.yml ```

## **Removing Debian Agents**

To remove a debian machine as an agent from Wazuh, run the following command

```ansible-playbook remove_agent_debian.yml```

## **Adding CentOS agents**

- The SOC team will give you a command to be run on the CentOS agents. Replace the command in *add_agent_centos.sh* with the command the SOC team has given you and then run the following command to add debian machines as an agent

``` ansible-playbook -vvv add_agent_centos.yml ```

## **Removing CentOS Agents**

To remove a debian machine as an agent from Wazuh, run the following command

```ansible-playbook remove_agent_centos.yml```
