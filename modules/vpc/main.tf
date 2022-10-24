# # Create aws vpc in newly created account
# resource "aws_vpc" "new_vpc" {
#     cidr_block = var.vpc_cidr
#     enable_dns_hostnames = true
#     tags = {
#         Name = "new vpc"
#     }

# }

# # locals {
# #     subnet_settings = {
# #         "subnet-1" = {availability_zone = "us-east-1b", cidr_block = "11.0.0.0/22"},
# #         "subnet-2" = {availability_zone = "us-east-1c", cidr_block = "10.0.0.0/23"},
# #         "subnet-3" = {availability_zone = "us-east-1d", cidr_block = "12.0.0.0/21"}
# #     }
  
# # }

# # Create subnets in different AZs
# # resource "aws_subnet" "new_subnet" {
# # #   for_each = local.subnet_settings
# #   count      = 3 # creates 3 different subnets
# #   vpc_id     = aws_vpc.new_vpc.id
# # #   availability_zone = each.value.availability_zone
# #   cidr_block = cidrsubnet(var.vpc_cidr, 3, count.index)
# # #   availability_zone_id = data.aws_availability_zones.availability_zone_ids[count.index % length(data.aws_availability_zones.availability_zone_ids)]
# #   map_public_ip_on_launch = true

# #   tags = {
# #     Name = tomap({"Name" = "${var.subnet_names[count.index]}"})
# #   }
# # }


# # create internet gateway
# resource "aws_internet_gateway" "gateway" {
#     vpc_id = aws_vpc.new_vpc.id
    
#     tags = {
#         Name = "Gateway"
#     }

#     depends_on = [
#       aws_vpc.new_vpc
#     ]
  
    
#  }

# # data "aws_availability_zones" "available" {

# #  }


# resource "aws_subnet" "new_subnet" {
#     count = "${length(data.aws_availability_zones.availabile.names)}"
#     vpc_id = aws_vpc.new_vpc.id
#     cidr_block = var.vpc_cidr
#     # availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
#     availability_zone = "us-east-1b"
#     map_public_ip_on_launch = true

#     tags = {
#         Name = "PublicSubnet"
#     }
  
# }


# resource "aws_route_table" "new_rt" {
#   vpc_id = aws_vpc.new_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gateway.id
#   }

#   tags = {
#     Name = "public_rt"
#   }
# }

# resource "aws_route_table_association" "public_rt_asso" {
#   subnet_id      = aws_subnet.new_subnet.id
#   route_table_id = aws_route_table.new_rt.id
# }