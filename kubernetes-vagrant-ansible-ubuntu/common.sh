################################# ABOUT ############################################
################################# Suchintan Mishra #################################   #
# This is a fully automated script that must be executed on all master and all workers.#
# Installs all the required dependencies for the running of kubernetes and docker.     #
####################################################################################   #
#!/bin/bash
echo "#########################common"
sudo sudo rm -rf /var/lib/apt/lists/*
sudo sudo apt-get clean
sudo -i apt-get update -y
sudo -i apt-get install ansible -y
ansible-playbook master-playbook.yml -vv