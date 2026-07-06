resource "aws_lb_target_group" "terraform_target_group" {
  name        = "webTG"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform_vpc.id
}
