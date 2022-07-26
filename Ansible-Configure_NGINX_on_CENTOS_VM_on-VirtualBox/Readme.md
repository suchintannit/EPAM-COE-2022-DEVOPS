
*********************
*Created by Suchintan*
*********************

**Scenario:** This is an example where we try to install the nginx service on a CENTOS host.
**Playground:** Create a CENTOS VM on Virtualbox an do the following:
	1. Create a NAT adapter and a bridged adapter and forward the port 22 (on the NAT Adapter for guest port 22 and host ip 127.0.0.1).
	2. In the host MAC os install sshpass.
	3. Run the YAML playbook using the command 
				_ansible-playbook -i inventory.cfg nginx_virtualbox.yml --ask-pass --ask-become-pass_

	NOTE: The ask-pass and ask-become-pass tell ansible the ssh password and the sudo password respectively. 

**Requirements:**
The example requires the following:
	_An CENT OS instance running on virtualbox_
	_A controller node with openssh, ansible installed and sshpass installed_
	
**Output:**

