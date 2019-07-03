# infra-automation
- Terraform script to automate infrastructure setup
- Sample terrafor script to automate infrastruture setup 
- This script creates EC2 instances, S3 buckets and RDS.
- This script also creates loadbalancers and map a domain name to the endpoint.
- EC2 template file contains the userdata code to setup the required tools on the instance.
- tfvars files contains the run time variable which nedds to be passed during terraform execution



File structure:

ec2
  - nonprod
    zone_name-vpc-instance_name.tfvars (e.g. euw1-np-vpc-server1.tfvars: contans non production variables)
  - prod
    zone_name-vpc-instance_name.tfvars (e.g. euw1-p-vpc-server1.tfvars: contans production variables)
  - template
    userdata.tpl (contains the shell code to setup tools on he server)
  - main.tf
  - output.tf
  - variables.tf
  
s3
  - nonprod
    zone_name-vpc-instance_name.tfvars (e.g. euw1-np-vpc-server1.tfvars: contans non production variables)
  - prod
    zone_name-vpc-instance_name.tfvars (e.g. euw1-p-vpc-server1.tfvars: contans production variables)
  - main.tf
  - output.tf
  - variables.tf
  
rds
  - nonprod
    zone_name-vpc-instance_name.tfvars (e.g. euw1-np-vpc-server1.tfvars: contans non production variables)
  - prod
    zone_name-vpc-instance_name.tfvars (e.g. euw1-p-vpc-server1.tfvars: contans production variables)
  - main.tf
  - output.tf
  - variables.tf
