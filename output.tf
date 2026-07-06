output "load_balancer_dns" {
  description = "The DNS name of the ALB to test the application"
  value       = aws_lb.web_alb.dns_name
}
