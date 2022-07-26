################################# ABOUT ############################################
################################# Suchintan Mishra #################################   #
# This is a fully automated script that must be executed on all workers ONLY.          #
# InThe Script joins the workers to a control plane.                                 #
####################################################################################   #
#!/bin/bash
#
# Setup for Node servers


sudo -i
sudo -i chmod +x /shared/join.sh
sleep 200
sudo -i bin/bash /shared/join.sh
printf "##### Worker-node Init #####\n"

