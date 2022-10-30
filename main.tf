
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
#   email  =  ""
#   role_name = "developer"
# }

# module "IAM" {
#   source = "./modules/IAM"

#   providers = {
#     aws = "aws.new_account"
#    }
# }




# Create terraform state file in backend
# terraform {
#   backend "s3" {
#     bucket         = "cyberhive-test-bucket"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-locking"
#     encrypt        = true
#   }
# }

# resource "aws_s3_bucket" "terraform_state" {
#   bucket        = "cyberhive-test-bucket"
#   force_destroy = true



# }

# resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_conf" {
#   bucket        = aws_s3_bucket.terraform_state.bucket 
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }



# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-state-locking"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }


module "aws_instance" {
  source = "./modules/EC2"
  vpc_id = "vpc-094268ea796fe93a4"

}

