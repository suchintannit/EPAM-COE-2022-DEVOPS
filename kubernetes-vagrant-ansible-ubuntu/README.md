#### AUTOMATION of KUBERNETES CLUSTER on UBUNTU using VAGRANT and Ansible scripts. 
**Author**-SUCHINTAN MISHRA [suchintan_mishra@epam.com]

### 1. Automated Creation of Kubernetes cluster on ubuntu: Using Vagrant and Ansible.

**Kubernetes**: Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available. Nodes (like VMs) and inside these nodes Pods (like Containers) are executed. Kubernetes works on a master-slave architecture where there is atleast one master and multiple workers.

**Docker** containers enable application developers to package software for delivery to testing, and then to the operations team for production deployment. The operations team then has the challenge of running Docker container applications at scale in production. Kubernetes is a tool to run and manage a group of Docker containers. While Docker focuses on application development and packaging, Kubernetes ensures those applications can run at scale. th

The project will create a Kubernetes 1.15.0 cluster with 3 nodes which contains the components below:

| IP           | Hostname | Componets                                |
| ------------ | -------- | ---------------------------------------- |
| 10.0.0.100 | k8s-master    | kube-apiserver, kube-controller-manager, kube-scheduler, etcd, kubelet, docker, flannel, dashboard |
| 10.0.0.101 | node01    | kubelet, docker, flannel, todo-myapp          |
| 10.0.0.102 | node02    | kubelet, docker, flannel, mysql-container               |

The default setting will create the private network from 10.0.0.100 to 10.0.0.102 for nodes, and it will use the host's DHCP for the public IP.The kubernetes service's VIP range is `10.13.0.0/16`. The container network range is `10.13.0.0/16` owned by flannel with `host-gw` backend. `kube-proxy` will run as `ipvs` mode. The project intitializes a control plane at the 'master' node and also installs the 'kubernetes-dashboard. The dashboard is available at:


### 2. Vagrant

**Vagrant** is a command line tool used to automate the formation of virtual machines (VMs). It is a good option to use vagrant to automate the creation of VMs on which our master and workers will run. For this example, the vagrantfile create 3 ubuntu 'nodes' running the vagrant box ubuntu. 


		PS>vagrant up

This command invokes the vagrantfile in the project.  Of the 3 nodes, one is the master and will run the kubernetes controller and dashboard. The master node is responsible to run the control plane. The control plane listens to REST API request. The worker nodes01 executes a python to-do docker container while the node02 stores its persitant database through a mysql container. This project demonstrates how a multi container app can be managed by a cluster. The vagrant file contains 3 basic variables

Once the master is created the vagrant file uses the "deploy-master.sh" and "deploy-network.sh" to provision it as a kubernetes _Master_. Also, when the worker nodes are created the vagrant file provisions them as _Workers_ using the "common.sh" and the "node.sh" scripts.

Once the master and nodes are up do the following:

	1.SSH into the master node from Powershell: vagrant ssh k8s-master(or node1/node2)
	
	2.In master node execute: kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
	
	3.Now turn into the worker nodes and run the output of kubeadm-init in the master node something like this
		kubeadm join 10.0.0.10:6443 --token d6c4tt.hp87qv9qel8s25zs --discovery-token-ca-cert-hash 			sha256:c3df3c0dbc6be18f59f180b535a4de1a37ba8082a2dfc638df1b01a1547b34fa
		
	4. Once the nodes join the master, In node1 install the to-do my app. In node2 install its persistant database.
	
	5. Follow the instaructions from https://docs.docker.com/get-started/02_our_app/#:~:text=%20Start%20an%20app%20container%20%F0%9F%94%97%20%201,items%20as%20complete%20and%20remove%20items.%20More%20
	
	6. Run the app on node1 and check in node2 if the database is being stored.

### 3. Ansible Scripts for Automation

Infrastructure as code (IaC) is the process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

Ansible is a suite of software tools that enables infrastructure as code. It is open-source and the suite includes software provisioning, configuration management, and application deployment functionality.

In contrast with other popular configuration-management software — such as Chef, Puppet, Salt and CFEngine — Ansible uses an agentless architecture, with Ansible software not normally running or even installed on the controlled node. Instead, Ansible orchestrates a node by installing and running modules on the node temporarily via SSH. For the duration of an orchestration task, a process running the module communicates with the controlling machine with a JSON-based protocol via its standard input and output. When Ansible is not managing a node, it does not consume resources on the node because no daemons are run or software installed.

In this project we have 2 ansible yml files **deploy-master** and **deploy-node**. The scripts are responsible to deploy kubernetes on master and worker nodes respectively. Once **creation of a cluster of 1 master and 2 worker nodes**, apps can be deployed as pods into the worker nodes. These scripts automate the entire process of setting of a kubernetes cluster. Also in the script we have 2 bash scripts .

**NOTE**:-These bash scripts are only used to install ansible in the master and worker nodes as I am working on a windows system where ansible cannot be installed ( it is very contrary to the fact that ansible is stateless and should not be installed in the target system). If you are working on an ubuntu system (which i recommend you do) then there is no need of the bash scripts. The automation can only be done using vagrant and ansible. On any vagrant, virtualbox and ansible installed ubuntu system just change the following in the vagrant file. Mind you if in the host system ansible can run then there is no need of vagrant either. the whole setup can be done only using ansible scripts.
		
		ansible.playbook = "deploy-master"
            	ansible.extra_vars = 
		{
                	node_ip: "192.168.50.10",
            	}
and delete the following lines in master creation block:

		master.vm.provision "file", source: "deploy-master.yml", destination: "master-playbook.yml"
        	master.vm.provision "shell", path: "deploy-master.sh"
and do, 
		ansible.playbook = "deploy-node"
            	ansible.extra_vars = 
		{
                	node_ip: "192.168.50.10",
            	}

and delete the following in the node block:

		node.vm.provision "file", source: "deploy-node.yml" , destination:"node-playbook.yml"
            	node.vm.provision "shell", path: "deploy-node.sh"

### 3. How the Tools (Vagrant, Ansible Docker and Ubuntu) Automation Works?
	 	 ______________________________________________________________________________________
		'											'
		'	 		''''''''''''\   kubeadm,kubectl,dashboard,REST			'
		' /----> Ansible --->	'k8s-master  / <<------------<----------- 			'
		'/			''''''''''''				'			'
		'						        	'			'
		'								'			'
		'								'
		'			''''''''''''\				'			'
	Vagrant-'----->	Ansible	 ---->	   Node01---->-> Docker Container <-<---- ' <----<----kubernetes'
		'	 			    /	  (To-do APP)		'		        '
	        '\			''''''''''''				'			'					
		' \								'
		' \								'
		'  \	   		''''''''''''				'			'
		'   \----->Ansible --->	'   Node02--->-> Docker Conatiner  <-<---			'
		'			''''''''''''	    (MySQL)					'
	 	'											'
		'______________________________________________________________________________________	'
		
### 6. How to deploy applications into pods?
	Step-1: List the nodes in your cluster after SSH into k8s-master, along with their labels:
	
		PS> kubectl get nodes --show-labels
	
	Step-2: Choose one of your nodes (say node1), and add a label to it:
	
		PS> kubectl label nodes node1 disktype=ssd
	
	Step-3: Check the above steps
		
		PS> kubectl get nodes --show-labels
		
	Step-4: Create a YML file to run the getting-started app discussed in docker documentation.
			apiVersion: v1
			kind: Pod
			metadata:
		  	  name: getting-started
		  	  labels:
			    env: test
		        spec:
			  containers:
			    - name: getting-started
			    image: 896325/suchintan-getting-started
  			    imagePullPolicy: IfNotPresent
  			  nodeSelector:
			    disktype: ssd
	Step-5: Inside node1 through SSH check:
		PS>kubectl get pods --output=wide
	 
### 5. Troubleshoot Execution.
Do a vagrant up the first time you execute. Let the process complete in one go. If it gets stuck then close the VMs from virtualbox and then do the follwoing options from the root folder.

	PS>vagrant reload --provision

	If there are errors then execute:

	PS> vagrant halt -f
	
	PS> vagrant up --provision
	

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


