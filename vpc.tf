resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform-vpc"
  }
}

resource "aws_internet_gateway" "terraform_internet_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "Terraform-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_internet_gateway.id
  }
  tags = {
    Name = "Terraform-public-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.terraform_public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  count = 2
}

resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  count    = 2
  tags = {
    Name = "terraform-nat-eip ${count.index + 1}"
  }
}

resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.terraform_public_subnet[count.index].id
  count = 2
  tags = {
    Name = "terraform-nat-gateway ${count.index + 1}"
  }
}


resource "aws_route_table" "private_route_table_0" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat_gateway[0].id
  }
  tags = {
    Name = "Terraform-private-route-table-0"
  }
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat_gateway[1].id
  }
  tags = {
    Name = "Terraform-private-route-table-1"
  }
}

resource "aws_route_table_association" "private_route_table_association_0" {
  subnet_id      = aws_subnet.terraform_private_subnet[0].id
  route_table_id = aws_route_table.private_route_table_0.id
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.terraform_private_subnet[1].id
  route_table_id = aws_route_table.private_route_table_1.id
}