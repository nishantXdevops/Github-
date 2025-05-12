
variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "ami_id" {
    type = string
    default =  "ami-0129865974a10c1cb"
     }

variable "key_name" {
    type = string
    default = "nishant"
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "instance_name"{
    type = string
    default = "testing"
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

# variable   "cidr_block" {
#     type =string
#     default = "0.0.0.0/0"
#  }