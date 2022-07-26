module "aws_instance_module"{
  source = "github.com/hashicorp/learn-terraform-modules-create.git"
  
}
resource "aws_instance" "app_server" {
    
ami = "ami-0cff7528ff583bf9a"
instance_type = "t2.micro"
#The template file contains the name of the instance and is defined in variables.tf.
tags ={
          Name = module.aws_instance_module.website_bucket_domain
      }
}