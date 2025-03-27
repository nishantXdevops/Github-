provider "aws" {
  region = var.region
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
  bucket = var.bucket
  acl    = "private"
}

# resource "aws_ec2_instance_state" "stop_instances" {
#  for_each       = toset(var.instance_ids)
#  instance_id    = each.value
#  state          = "stopped"
# }