resource "aws_lb" "web_alb" {
  name               = "web-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = [aws_subnet.terraform_public_subnet[0].id, aws_subnet.terraform_public_subnet[1].id]


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform_target_group.arn
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                = "web-app-asg"
  vpc_zone_identifier = [aws_subnet.terraform_private_subnet[0].id, aws_subnet.terraform_private_subnet[1].id]
  target_group_arns   = [aws_lb_target_group.terraform_target_group.arn]

  desired_capacity = 2
  min_size         = 2
  max_size         = 4
  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cpu_tracking" {
  name                   = "cpu-target-tracking-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0 # Scale out if average CPU hits 50%
  }
}
