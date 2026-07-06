resource "aws_db_instance" "db" {
  allocated_storage      = 20
  db_name                = "webdb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "password123"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.terraform_private_subnet[0].id, aws_subnet.terraform_private_subnet[1].id]

  tags = {
    Name = "DB subnet group"
  }
}
