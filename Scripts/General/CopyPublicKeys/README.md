# Ansible Playbook to Copy Public Keys to Machine

## Usage

1. `ansible-playbook -i <inventory-file> deploy_authorized_keys.yml --ask-pass --extra-vars='pubkey="<pubkey>"`

2. Enter password for each machine