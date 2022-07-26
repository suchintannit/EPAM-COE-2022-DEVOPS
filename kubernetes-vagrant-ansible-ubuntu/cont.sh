################################# ABOUT ############################################
################################# Suchintan Mishra #################################   #
# This is a fully automated script that must be executed on all master and all workers.#
# Installs all the required dependencies for the running of kubernetes and docker.     #
####################################################################################   #
#!/bin/bash

sudo rm /etc/containerd/config.toml
sudo -i systemctl restart containerd
