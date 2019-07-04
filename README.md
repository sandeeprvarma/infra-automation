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


SETUP: (nonprod)

1. Install Terraform and AWS cli and run 'aws configure' command to seup aws account. 
```
aws configure
AWS Access Key ID [None]: ACCESS_KEY
AWS Secret Access Key [None]: ACCESS_SECRET_KEY
Default region name [None]: REGION
Default output format [None]: json
```

2. after configuring aws account use the below code to initialize terraform for EC2

```
terraform init --var-file=nonprod/usw2-np-testserver.tfvars 
```

3. Now we can use terraform plan to check what will happen we apply these changes. It will not crete any resourse.
```
terraform plan --var-file=nonprod/usw2-np-testserver.tfvars 
```

4. Run terrafor apply to create the aws instances
```
terraform apply --var-file=nonprod/usw2-np-testserver.tfvars 
```
similarly, we can create S3 and RDS.
