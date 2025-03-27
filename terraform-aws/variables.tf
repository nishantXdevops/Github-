variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type    = string
  default = "ami-0129865974a10c1cb"
}

variable "key_name" {
  type    = string
  default = "nishant"
}

variable "bucket_prefix" {
  type    = string
  default = "my-unique-bucket-nishant"
}

variable "security_group_name" {
  type    = string
  default = "nishant-security"
}

variable "security_group_description" {
  type    = string
  default = "Allow SSH and HTTP"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

variable "user_data" {
  type    = string
  default = <<-EOF
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

variable "instance_ids" {
  type    = list(string)
  default = ["i-0dc3c2999465ca57f"]  # Replace with your instance IDs
}
