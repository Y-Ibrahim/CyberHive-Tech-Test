variable "test-server-sg" {
    description = "name of the test-server security group"
    default     = "test-server-sg"
}

variable "instance_name" {
    description = "name of newly created instance"
    default     = "test-server"
  
}

variable "vpc_id" {
    description = "id of newly created VPC"
    type = string
  
}

variable "vpc_cidr" {
    description = "CIDR range for VPC"
    default     = "10.0.0.0/16"
  
}

variable "subnet_cidrs" {
    description = "Subnet CIDRs"
    default = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
    type = list
}

variable "availability_zones" {
    description = "availability zones for subnets"
    default = ["us-east-1a", "us-east-1b", "us-east-1c"] 
}

variable "secondary_subnet_names" {
    description = "names for the subnets"
    default = ["new_subnet-01", "new_subnet-02", "new_subnet-03"]
}

variable "configuration" {
    description = "the configuration of subnets"
    type = map(object({
        cidr = string
        availability_zone = string
        tags = map(string)
    }))
    default = {
      "subnet_01" = {
        availability_zone = "us-east-1a"
        cidr = "10.0.6.0/24"
        tags = {
            Name = "new_subnet-01"
        }
      }
      "subnet_02" = {
        availability_zone = "us-east-1b"
        cidr = "10.0.7.0/24"
        tags = {
            Name = "new_subnet-02"
        }
      }
      "subnet_03" = {
        availability_zone = "us-east-1c"
        cidr = "10.0.8.0/24"
        tags = {
            Name = "new_subnet-03"
        }
      }
    }
}