# EPAM-COE-2022-DEVOPS

### What is DevOps?
Development and Operations (DevOps) is a set of practices that combines software development (Dev) and IT operations (Ops). It aims to shorten the systems 
development life cycle and provide continuous delivery with high software quality. Since the software develeopment is transported across departments, it is not 
suitable to do a on-prem development. DevOps tools provide us with the ease to write the code in such a way so that it can be easily be transported and changed across 
departmemnts.

### How DevOps tools can help?

Devops automates the production and development in 3 steps. 
  Step 1: Automated Creation of Resources
  Step 2: Automated Deployment of Applications
  Step 3: Automated Monitoring.
The table below shows which tools is useful in which context.

| Technology    | Automation Level          | Alternatives                     | Path in Repo|
| ------------- | --------------------      | -------------------------        |----------   |
| Vagrant       | Resource Creation         | Terraform, AWS CLOUD Formation   |             |
| Terraform     | Resource Creation         | Vagrant, AWS CLOUD FOrmation     |             |
|Ansible        | Application deployment    | CHEF, Puppet                     |             |     
|Docker         | Application deployment    |                                  |             |             
|Kubernetes     | Resource Monitoring       | Kubernetes Charm, AWS EKS        |             |
