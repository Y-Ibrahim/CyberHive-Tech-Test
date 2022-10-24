
# # Create IAM user and assign password for console access
# module "aws_iam_account" {
#   source = "./modules/iam"
#   name   = "module-test"
# }

# # Create IAM role to provide user with permissions for creating VPC and EC2 resources
# resource "aws_iam_role" "test_role" {
#   name = "test_role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

# create aws organizational account
# module "aws_account" {
#   source =  "./modules/account"
#   name   =  "development_account"
#   email  =  "gloomkid@hotmail.com"
#   role_name = "developer"
# }

# module "IAM" {
#   source = "./modules/IAM"

#   providers = {
#     aws = "aws.new_account"
#    }
# }





# module "aws_vpc" {
#   source = "./modules/vpc"
# }

# Create terraform state file in backend
terraform {
  backend "s3" {
    bucket = "Cybherhive-test-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}



module "aws_instance" {
  source = "./modules/EC2"
  vpc_id = "vpc-094268ea796fe93a4"
  
} 

