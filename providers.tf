# default to local backend for state
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Default AWS Provider
provider "aws" {
  region = "us-east-1"
}




# Provider for newly created aws account
provider "aws" {
  alias  = "new_account"
  region = "us-east-1"
  # other provider config
  assume_role {
    # Assume the organization access role
    role_arn = "arn:aws:iam::${aws_organizations_account.developer.id}:role/developer"
  }
}
