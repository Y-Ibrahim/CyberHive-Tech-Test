# CyberHive-Tech-Test
1. The user should produce a Terraform script that:
a. Creates an AWS account
b. Builds a VPC within that account meeting the following criteria:

i. A CIDR block of 10.0.0.0/16
ii. Three subnets spread across different availability zones
iii. Has internet access (either internet gateway or NAT gateway)

c. Creates a small Ubuntu EC2 instance

i. The EBS volume of the instance should be encrypted with a customer-
managed KMS key.

ii. The instance security group should allow SSH, HTTP and HTTPs traffic
2. The user should then produce Ansible code that performs the following:
a. Configured the system hostname
b. Set the timezone to Europe/London
c. Configure IPTables rules to allow traffic on port 22; 80; 443; established and related
connections; ICMP from anywhere and have a standard input policy of DROP.
d. Installs Apache2 with apt
e. Ensure that Apache2 is started and it’s service is enabled on startup
3. The completed code should be pushed to GitHub and shared with us.


# How to run script
run ssh-keygen -f test-key

terraform init

terraform apply

# Account
contains resources for setting up an AWS account via AWS organizations, currently not functioning

# EC2
contains resources for building out the ec2 instance, as well as the security group, vpc, subnet and ig

# ansible
contains yaml files needed to configure the newly created instance