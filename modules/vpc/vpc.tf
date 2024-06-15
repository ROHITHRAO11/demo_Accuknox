resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "VPC for EC2 instance"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

