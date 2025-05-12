
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "nishant_vpc" {
cidr_block =  "10.0.0.0/16"

  tags = {
    Name = "nishant-vpc"
  }
}

# Subnet
resource "aws_subnet" "nishant_subnet" {
  vpc_id            = aws_vpc.nishant_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "nishant-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "nishant_igw" {
  vpc_id = aws_vpc.nishant_vpc.id

  tags = {
    Name = "nishant-igw"
  }
}

# Route Table
resource "aws_route_table" "nishant_route_table" {
  vpc_id = aws_vpc.nishant_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.nishant_igw.id
  }

  tags = {
    Name = "nishant-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.nishant_subnet.id
  route_table_id = aws_route_table.nishant_route_table.id
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.nishant_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami           = var.ami_id # Ubuntu 20.04 in us-east-1 (you can change)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.nishant_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  key_name = var.key_name # Replace with your actual key pair name

  tags = {
    Name = "nishant-ec2"
  }
}
