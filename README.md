Creating a new web application infrastructure in AWS.  This web application will be generally available to external users on the public Internet.

Using HashiCorp's Terraform, creating all required objects to fulfill the requirements to provide external access and ensure availability. 

**Description:**
1)    Only the us-east-1 region is available
1)    Using publicly available AMI 'Apache Web Server, id: ami-26950f4f, or other alternative web server.
2)    Utilizing the t2.micro instance type
3)    Creating an auto-scaling group with a min/max size of 3/5 
4)    Exposing the server externally such that only ingress traffic on port 80/443 is allowed.  Egress traffic is unrestricted.
5)    Creating user-based S3 role that provides read/write access to a specific S3 bucket named s3-bucket

**How to run this code?**

To Apply:
*terraform plan -var 'key_name={your_key_name}'*

After applying, please wait for a few mins before hitting the ELB since it takes a minute or so for the instances to show InService under ELB:

*terraform apply -var 'key_name={your_key_name}'*


To destroy the environment:

*terraform destroy -var 'key_name={your_key_name}'*
