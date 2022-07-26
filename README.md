# EPAM-COE-2022-DEVOPS

### What is DevOps?
Development and Operations (DevOps) is a set of practices that combines software development (Dev) and IT operations (Ops). It aims to shorten the systems 
development life cycle and provide continuous delivery with high software quality. Since the software develeopment is transported across departments, it is not 
suitable to do a on-prem development. DevOps tools provide us with the ease to write the code in such a way so that it can be easily be transported and changed across 
departmemnts.

### How DevOps tools can help?

Devops automates the production and development in 3 steps:

                       Creation     Application Deployment    Monitoring
                      -----------\      ---------------\      ---------\
                      -----------/      ---------------/      ---------/
            
  Step 1: **Automated Creation of Resources:** If a SW developer wants to automate creation of resources only and wants to leave everything else for later the tools like VAGRANT and TERRAFORM can help.
  
  Step 2: **Automated Deployment of Applications:** If a SW developer wants to automate creation of resources and deployment of applications and wants to leave everything else for later the tools like VAGRANT+DOCKER or VAGRANT+Ansible or TERRAFORM+DOCKER can help.
 
 Step 3: **Automated Monitoring:** If a SW developer wants to automate everything the tools like VAGRANT+Ansible+Kubernetes and TERRAFORM+CHEF+Kubernetes can help.
The table below shows which tools is useful in which context.

          | Technology    | Automation Level          | Alternatives                     | Path in Repo|
          | ------------- | --------------------      | -------------------------        |----------   |
          | Vagrant       | Resource Creation         | Terraform, AWS CLOUD Formation   |             |
          | Terraform     | Resource Creation         | Vagrant, AWS CLOUD FOrmation     |             |
          |Ansible        | Application deployment    | CHEF, Puppet                     |             |     
          |Docker         | Application deployment    |                                  |             |             
          |Kubernetes     | Resource Monitoring       | Kubernetes Charm, AWS EKS        |             |
