################################# ABOUT ############################################
################################# Suchintan Mishra #################################   #
# This is a fully automated script that must be executed on all master and all workers.#
# Installs all the required dependencies for the running of kubernetes and docker.     #
####################################################################################   #
#!/bin/bash

#Parameters
master_ip="10.0.0.10"
worker_ip="10.0.0.1"
#Update apt Packages
printf "##### Updating apt Packages #####\n"
sudo apt-get update -y
#Upgrade apt Packages. Takes a lot of time be patient and be in a good internet environment. But since this 
#is the most important step please do not skip.
#Install and Start Docker
printf "##### Installing Docker #####\n"
sudo apt-get install -y docker.io -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt-get update -y
sudo apt-cache policy docker-ce
sudo apt-get install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
#Install the Firewalld
sudo apt-get install firewalld -y
sudo systemctl enable firewalld
sudo systemctl start firewalld
#open firewall ports
#Add Firewall-Rules to Ports
printf "##### Adding Firewall Rules #####\n"
sudo firewall-cmd --zone=trusted --add-interface=cni0 --permanent
sudo firewall-cmd --permanent --add-port=443/tcp 
sudo firewall-cmd --permanent --add-port=6443/tcp 
sudo firewall-cmd --permanent --add-port=30000-32767/tcp 
sudo firewall-cmd --permanent --add-port=8285/udp 
sudo firewall-cmd --permanent --add-port=8472/udp 
sudo firewall-cmd --permanent --add-port=179/tcp 
sudo firewall-cmd --permanent --add-port=2379-2380/tcp 
sudo firewall-cmd --permanent --add-port=10250/tcp 
sudo firewall-cmd --permanent --add-port=10251/tcp 
sudo firewall-cmd --permanent --add-port=10252/tcp 
sudo firewall-cmd --permanent --add-port=10255/tcp 
sudo firewall-cmd --permanent --add-port=10300/tcp 
sudo firewall-cmd --permanent --add-port=8090/tcp
sudo systemctl restart firewalld
#Add Kubernetes Repository
printf "##### Adding Kubernetes Repository #####\n"
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-get install keepalived -y
systemctl enable keepalived
systemctl start keepalived
#Clear Iptables
printf "##### Clearing Iptables #####\n"
iptables --flush
iptables -tnat --flush
Firewall modules reload
printf "##### Enabling Firewalls Modules #####\n"
modprobe br_netfilter
#echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo sysctl net.bridge.bridge-nf-call-iptables=1
printf "##### Disabling SWAP anf UFW #####\n"
sudo swapoff -a
sudo ufw disable
