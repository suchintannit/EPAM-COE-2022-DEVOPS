################################# ABOUT ############################################
################################# Suchintan Mishra #################################   #
# This is a fully automated script that must be executed on all masters ONLY.          #
# InThe Script starts a control plane at master nodes.                                 #
####################################################################################   #
#!/bin/bash
sudo ufw status
sudo ufw disable
sudo systemctl disable firewalld
sudo systemctl status firewalld
#make use the owner
# Run the below commands on Master Node to run Kubernetes cluster with a regular user
   # Creating a directory that will hold configurations such as the admin key files, which are required to connect to the cluster, and the cluster’s API address.
   mkdir -p $HOME/.kube
   # Copy all the admin configurations into the newly created directory 
   sudo cp -i /etc/Kubernetes/admin.conf $HOME/.kube/config
   # Change the user from root to regular user that is non-root account
   sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Prefilght images
 rm /etc/containerd/config.toml
systemctl restart containerd
kubeadm reset -f
kubeadm config images pull
echo "\nPreflight Check Passed: Downloaded All Required Images\n"

#initialize control plane
kubeadm init  --apiserver-advertise-address="10.0.0.10" --pod-network-cidr="10.244.0.0/16"  --apiserver-cert-extra-sans "10.0.0.10" --ignore-preflight-errors Swap --ignore-preflight-errors=NumCPU
echo "\nK8s Control Plane Successful\n"

#Print and store the kubeadm join command
echo "\n Printing the Kubeadm join command."
touch /shared/join.sh
chmod +x /shared/join.sh
kubeadm token create --print-join-command>/shared/join.sh
echo "\nAdmin Conf Directory Made. ENV variable exported\n"
#Test the control plane
sleep 500
#Apply the calico network
mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
echo "##########Testing the Master Control Plane\n";
kubectl get nodes
# Establishing the Network connectivity between two MASTER AND WORKER
 kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
 echo "\nNetwork Appplied\n"
echo "\nInstall Metrics Server\n"
kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
#Install the dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
#kubectl create serviceaccount dashboard-admin-sa
#kubectl get secrets
#kubectl describe secret dashboard-admin-sa-token-cfpcs
#kubectl proxy --port 8080
#Printfing the Nodes
sudo -i kubectl get nodes
