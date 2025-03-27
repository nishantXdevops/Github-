variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "region" {
   type = string
   default = "us-east-1"
}

variable "ami_id" {
  type = string
  default = "ami-0129865974a10c1cb"
}  

variable "key_name" {
   type = string 
   default = "nishant"
}   

variable "bucket" {
    type = string
    default = "my-unique-bucket-nishant"
}

variable "user_data" {
  type        = string
  default     = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io

# Start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add the default Ubuntu user to the Docker group (to run Docker without sudo)
sudo usermod -aG docker ubuntu

# Apply changes without requiring a reboot
newgrp docker
EOF

}

variable "instance_names" {
  type    = list(string)
  default = ["nishant"]
}

resource "aws_security_group" "my_sg" {
  name        = "nishant-security"
  description = "Allow SSH and HTTP"

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
    Name = "nishant-Security"
  }
}

variable "instance_ids" {
  type    = list(string)
  default = ["i-0dc3c2999465ca57f"]  # Replace with your instance IDs
}
