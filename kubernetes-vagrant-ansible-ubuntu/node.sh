################################# ABOUT ############################################
################################# Suchintan Mishra #################################   #
# This is a fully automated script that must be executed on all master and all workers.#
# Installs all the required dependencies for the running of kubernetes and docker.     #
####################################################################################   #
#!/bin/bash

sudo apt-get update -y
sudo apt-get install ansible -y
ansible-playbook node-playbook.yml