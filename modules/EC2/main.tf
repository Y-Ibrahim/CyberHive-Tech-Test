# Create key pair for ssh
resource "aws_key_pair" "test_server-key"  {
  key_name   = "test-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9LkBYbJi9tb8/yGqL0GcjZulkxaB+wvxupNV6dlv3HhAVbxWrQIz4qWzoeRVjHXX3YRmlfl2TjgFOCCqbgudDzEG4b9k14FswyxsXeaGnOtjzTKL4gsnFF5h6OvvJggrj4xJpmSi5ssWa8M7LAYTcfrkJgs6TOHmCxiRV/67TOCuAAwPHyUgDnTvG6zRqsIZrQUlXRVPlwfcm+0+8Jqk6DUXllrcYAC6d0zk7f+XZZlI9tp4f5mvngTE4gs67oNNhnL8gjcNJmlrEElSrFmBEWgQK59aPWtMVHMHGynubEzBq3QdZrFI6s3O2ekAFvw/37qIiP9FgSPdboESbZ/9t yousuf@DESKTOP-EADUSDQ"


}

# Create new vpc
resource "aws_vpc" "new_vpc" {
  cidr_block       = var.vpc_cidr


  tags = {
    Name = "main"
  }
}

# create security group for instances
resource "aws_security_group" "test_server_sg" {
  name = var.test-server-sg
  description = "allow SSH, HTTP and HTTPs traffic for this instance"
  vpc_id = aws_vpc.new_vpc.id

  ingress {
    description      = "TLS"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "to allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "to allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "to allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }




  tags = {
    Name = "test-server"
  }
  
}


# Create 3 new subnets within the newly created vpc
 resource "aws_subnet" "new_subnets" {
  for_each = var.configuration
  cidr_block = each.value.cidr
  vpc_id = aws_vpc.new_vpc.id
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

# Create network interface in each EC2 instance
# resource "aws_network_interface" "foo" {
#   for_each = var.configuration
#   subnet_id   = aws_subnet.my_subnet.id
#   private_ips = ["172.16.10.100"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }

# launch ec2 instance in each subnet
resource "aws_instance" "test_server" {
  for_each = var.configuration
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_server_sg.id]
  key_name = "test-key"
  associate_public_ip_address = true
  subnet_id = aws_subnet.new_subnets[each.key].id
  user_data =  <<-EOF
                #!/bin/bash
                echo "*** Installing apache2"
                sudo apt update -y
                sudo apt install apache2 -y
                echo "*** Completed Installing apache2"
                EOF


  
  
  # remote-exec provisioner will wait until an ssh connection can be made and run local-exec
  # provisioner "remote-exec" {
  #   inline = ["echo 'Wait until SSH is ready'"]

  #   connection {
  #     type = "ssh"
  #     user = "ubuntu"
  #     private_key = file("./test-key")
  #     host = aws_instance.test_server.*.public_ip
  #   }
  # }  

  # provisioner "local-exec" {
  #   command = "ansible-playbook -i ${aws_instance.test_server.*.public_ip}, --private-key ./test-key ./ansible/apache-install.yaml"
  # }          
  
 
  tags = {
    "Name" = each.key
  }

  depends_on = [
    aws_subnet.new_subnets
  ]
}

# Create route table, attach vpc igw 
resource "aws_route_table" "new_rt" {
  vpc_id = aws_vpc.new_vpc.id
  # vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt"
  }
}



# Associate each subnet with the custom route table
resource "aws_route_table_association" "public_rt_asso" {
  for_each = var.configuration
  subnet_id      = aws_subnet.new_subnets[each.key].id
  route_table_id = aws_route_table.new_rt.id

  depends_on = [
    aws_route_table.new_rt
  ]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = "test-igw"
  }
}