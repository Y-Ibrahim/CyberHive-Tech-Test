# Create key pair for ssh
resource "aws_key_pair" "test_server-key"  {
  key_name   = "test-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9LkBYbJi9tb8/yGqL0GcjZulkxaB+wvxupNV6dlv3HhAVbxWrQIz4qWzoeRVjHXX3YRmlfl2TjgFOCCqbgudDzEG4b9k14FswyxsXeaGnOtjzTKL4gsnFF5h6OvvJggrj4xJpmSi5ssWa8M7LAYTcfrkJgs6TOHmCxiRV/67TOCuAAwPHyUgDnTvG6zRqsIZrQUlXRVPlwfcm+0+8Jqk6DUXllrcYAC6d0zk7f+XZZlI9tp4f5mvngTE4gs67oNNhnL8gjcNJmlrEElSrFmBEWgQK59aPWtMVHMHGynubEzBq3QdZrFI6s3O2ekAFvw/37qIiP9FgSPdboESbZ/9t yousuf@DESKTOP-EADUSDQ"


}

# create security group for instance
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


# launch ec2 instance 
resource "aws_instance" "test_server" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_server_sg.id]
  key_name = "test-key"
  associate_public_ip_address = true
  subnet_id = aws_subnet.new_subnet.id
  
  # remote-exec provisioner will wait until an ssh connection can be made and run local-exec
  provisioner "remote-exec" {
    inline = ["echo 'Wait until ssH is ready'"]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("./test-key")
      host = aws_instance.test_server.public_ip
    }
  }  

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.test_server.public_ip}, --private-key ./test-key ./ansible/apache-install.yaml"
    # command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./test-key -i '${aws_instance.test_server.public_ip},' ./ansible/apache-install.yaml"
  }          
  
 
  tags = {
    "Name" = var.instance_name 
  }
}

resource "aws_vpc" "new_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "new vpc"
    }

}

# create internet gateway
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.new_vpc.id
    
    tags = {
        Name = "Gateway"
    }

    depends_on = [
      aws_vpc.new_vpc
    ]
  
    
 }


# Create subnet
resource "aws_subnet" "new_subnet" {
    # count = "${length(data.aws_availability_zones.availabile.names)}"
    vpc_id = aws_vpc.new_vpc.id
    cidr_block = var.vpc_cidr
    # availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true

    tags = {
        Name = "PublicSubnet"
    }
  
}

# Create route table and associate it with subnet
resource "aws_route_table" "new_rt" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.new_subnet.id
  route_table_id = aws_route_table.new_rt.id
}