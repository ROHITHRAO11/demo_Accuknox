resource "aws_eip" "main" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = var.name
  }
}

output "nat_id" {
  value = aws_nat_gateway.main.id
}

output "eip" {
  value = aws_eip.main.public_ip
}

