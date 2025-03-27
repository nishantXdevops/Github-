provider "aws" {
  region = var.region
}

resource "aws_security_group" "my_sg" {
  name        = "${var.security_group_name}-${random_string.suffix.result}"
  description = var.security_group_description

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.security_group_name}-${random_string.suffix.result}"
  }
}

resource "aws_instance" "instances" {
  for_each               = toset(var.instance_names)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = each.value
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_prefix}-${random_string.suffix.result}"
}

# 🔴 ❌ Remove the aws_s3_bucket_acl Resource ❌ 🔴
