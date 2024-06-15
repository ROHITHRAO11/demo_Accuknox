variable "ami" {
  description = "The AMI ID"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "sg_id" {
  description = "The ID of the Security Group"
  type        = string
}

variable "name" {
  description = "The name of the EC2 instance"
  type        = string
}


