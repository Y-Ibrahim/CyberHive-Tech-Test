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