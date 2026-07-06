resource "aws_subnet" "terraform_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  count             = 2
  map_public_ip_on_launch = true
  tags = {
    Name = "Terraform-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "terraform_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  count             = 2
  tags = {
    Name = "Terraform-private-subnet-${count.index + 1}"
  }
}