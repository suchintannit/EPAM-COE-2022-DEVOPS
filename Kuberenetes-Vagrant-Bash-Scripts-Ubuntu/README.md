#### AUTOMATION of KUBERNETES CLUSTER on UBUNTU using VAGRANT and BASH scripts. 
**Author**-SUCHINTAN MISHRA [suchintan_mishra@epam.com]

### 1. Architecture

**Kubernetes**: Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available. Nodes (like VMs) and inside these nodes Pods (like Containers) are executed. Kubernetes works on a master-slave architecture where there is atleast one master and multiple workers.

**Docker** containers enable application developers to package software for delivery to testing, and then to the operations team for production deployment. The operations team then has the challenge of running Docker container applications at scale in production. Kubernetes is a tool to run and manage a group of Docker containers. While Docker focuses on application development and packaging, Kubernetes ensures those applications can run at scale.

The project will create a Kubernetes 1.15.0 cluster with 3 nodes which contains the components below:

| IP           | Hostname | Componets                                |
| ------------ | -------- | ---------------------------------------- |
| 10.0.0.10 | master    | kube-apiserver, kube-controller-manager, kube-scheduler, etcd, kubelet, docker, flannel, dashboard |
| 10.0.0.11 | node01    | kubelet, docker, flannel, todo-myapp          |
| 10.0.0.12 | node02    | kubelet, docker, flannel, mysql-container               |

The default setting will create the private network from 10.0.0.10 to 10.0.0.12 for nodes, and it will use the host's DHCP for the public IP.The kubernetes service's VIP range is `10.13.0.0/16`. The container network range is `10.13.0.0/16` owned by flannel with `host-gw` backend. `kube-proxy` will run as `ipvs` mode. The project intitializes a control plane at the 'master' node and also installs the 'kubernetes-dashboard. The dashboard is available at:


### 2. Vagrant

**Vagrant** is a command line tool used to automate the formation of virtual machines (VMs). It is a good option to use vagrant to automate the creation of VMs on which our master and workers will run. For this example, the vagrantfile create 3 ubuntu 'nodes' running the vagrant box ubuntu. 

To execute this whole project just execute the following in the root folder in Powershell as the administrator. Please ADD A BLANK Folder named 'shared' in the root folder.

		PS>vagrant up

This command invokes the vagrantfile in the project.  Of the 3 nodes, one is the master and will run the kubernetes controller and dashboard. The master node is responsible to run the control plane. The control plane listens to REST API request. The worker nodes01 executes a python to-do docker container while the node02 stores its persitant database through a mysql container. This project demonstrates how a multi container app can be managed by a cluster. The vagrant file contains 3 basic variables

**NUM_WORKER_NODES=1** - Defines the number of worker nodes.

**IP_NW="10.0.0."** - Defines the IP range in which nodes will be created.

**IP_START=10** - The last octate of MASTER IP address.

Once the master is created the vagrant file uses the "common.sh" and "master.sh" to provision it as a kubernetes _Master_. Also, when the worker nodes are created the vagrant file provisions them as _Workers_ using the "common.sh" and the "node.sh" scripts.

### 3. How the Tools (Vagrant, Script and Ubuntu) Automation Works?
	 	 ______________________________________________________________________________________
		'											'
		'	 common.sh	''''''''''''\   kubeadm,kubectl,dashboard,REST			'
		' /----> master.sh --->	'   Master  / <<------------<------------- 			'
		'/			''''''''''''				'			'
		'								'			'
		'								'			'
		'								'
		'	common.sh	''''''''''''\				'			'
	Vagrant-'----->	node.sh	 ---->	   Node01---->-> Docker Container <-<---- ' <----<----kubernetes'
		'	 			    /	  (To-do APP)		'		        '
	        '\			''''''''''''				'			'					
		' \								'
		' \								'
		'  \	   common.sh	''''''''''''				'			'
		'   \----->node.sh --->	'   Node02--->-> Docker Conatiner  <-<----'			'
		'			''''''''''''	    (MySQL)					'
	 	'											'
		'______________________________________________________________________________________	'
		
	 
	 
### 5. Troubleshoot Execution.
Do a vagrant up the first time you execute. Let the process complete in one go. If it gets stuck then close the VMs from virtualbox and then do the follwoing options from the root folder.

	PS>vagrant reload --provision

	If there are errors then execute:

	PS> vagrant halt -f
	
	PS> vagrant up --provision
	
### Bash Scripts for Automation

Bash is a Unix command line interface for interacting with the operating system, available for Linux and macOS. Bash scripts help group commands to create a program. All instructions that run from the terminal work in Bash scripts as well.

Bash scripting is a crucial tool for system administrators and developers. Scripting helps automate repetitive tasks and interact with the OS through custom instruction combinations. The skill is simple to learn and requires only basic terminal commands to get started.

You will often encounter shell scripts starting with #! /bin/bash, #! is called a shebang or hashbang. shebang plays an important role in shell scripting, especially when dealing with different types of shells.
### 7. Explanation of Output During the Execution of "common.sh" file.
	PS>"Installing Docker"

	Until this step in the common.sh we try to download all images required for the kudeadm configuration. This step without errors signifies that we are now ready to deploy our control plane. Adding Kubernetes Repository. Adding Firewall Rules. Deactivatind 	Firewall. Disabling SWAP

	PS>"Adding Kubernetes Repository"

	Now, run the apt-add-repository command to add the Kubernetes package repository in Ubuntu. You must perform the following steps:
	
		printf "##### Adding Kubernetes Repository #####\n"
		sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
		echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list


	PS>"Adding Firewall Rules"



	PS>"Deactivatind Firewall"



	PS>"Disabling SWAP".

 

### 8. Explanation of Output During the Execution of "master.sh" file.


	PS>"Preflight Check Passed: Downloaded All Required Images".

	Until this step in the master.sh we try to download all images required for the kudeadm configuration. This step without errors signifies that we are now ready to deploy our control plane.

	PS>"K8s Control Plane Successful".

	After this output you can be certain that the init command has been executed and the control plane is now running at 10.0.0.10 and the api-server is listening to that address.

	PS>"Admin Conf Directory Made. ENV variable exported".

	The admin configuration directory is made through the following commands which have to be executed 

	*as root:

		$ export KUBECONFIG=/etc/kubernetes/admin.conf
	
	*or as others:

		$ mkdir -p "$HOME"/.kube
  		$ cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
 		$ chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
	
	PS>"Network Appplied".

	Flannel in Kubernetes is a virtual layer that is used with containers, it is designed basically for containers only. The above output shows that a network for pods has been created.

	PS>"Join Sh Created".

	Until this step in the master.sh we try to download all images required for the kudeadm configuration. This step without errors signifies that we are noe 		readyt to deploy our control plane.

	PS>"Install Calico Network Plugin".

	After this output you can be certain that the init command has been executed and the control plane is now running at 10.0.0.10 and the api-server is listening 		to that address.

	PS>

### 9. Explanation of the node.sh file.

This script is meant to make the _workers_ join the working _master_. The 'master.sh' script while deploying the master will create the print-join command that can be used to make the workers join a cluster. node.sh automates by executing this script.
### 10. FAQs.
Error FAQs:

	Error: Long wait during execution of certain commands. {processing triggers for man-db, generating initramfs, get package #118}. 
	Solution: All these are normal. Make sure you have a good internet connection and stay online.
	Error: System not running as sudo.
	Solution: Make sure vagrant and virtualbox are not blocked on your host system and have sufficient privilleges.
	Error: Unspecified filesystem vboxfs.
	Solution: Try to change the version of ubuntu in main vagrantfile.
	
Question: What is SWAP space and why it must be disabled in kubernetes master and worker nodes?

Answer: **Swap space** is a space on a hard disk that is a substitute for physical memory. It is used as virtual memory which contains process memory images. Whenever our computer runs short of physical memory it uses its virtual memory and stores information in memory on disk. Swap space helps the computer’s operating system in pretending that it has more RAM than it actually has. It is also called a swap file. To summarize, the lack of swap support lies in the fact that swap usage is not even expected in Kubernetes and there are enormous work to be done before swap can be used in product scenarios. IMHO, these work are no just about Kubernets itself but also enven more about Linux kernel. It might be problem for the Kubernetes community to find a strong motivation to tackle this issue considering the huge amount of efforts ahead.

Question: Why the **Master-Slave** Architecture and how it helps in production?

Answer: The master node in a Kubernetes architecture is used to manage the states of a cluster. It is actually an entry point for all types of administrative tasks. In the Kubernetes cluster, more than one master node is present for checking the fault tolerance.


