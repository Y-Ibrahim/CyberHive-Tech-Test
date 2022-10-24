variable "vpc_cidr" {
    description = "CIDR range for VPC"
    default     = "10.0.0.0/16"
  
}



variable "subnet_names" {
  type = list(string)
  default = [
    "Subnet 1",
    "Subnet-2",
    "Subnet-3"
  ]
}