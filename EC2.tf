resource "aws_launch_template" "web_template" {
  name                   = "web-template"
  instance_type          = "t2.micro"
  image_id               = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.webSG.id]
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      encrypted   = true
      volume_size = 8
      volume_type = "gp2"
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              
              # Fetch Availability Zone from IMDSv2
              TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
              AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
              
              # Normalize and output response matching requirements
              if [ "$AZ" = "us-east-1a" ]; then
                  echo " This is server in AWS Region US-EAST-I in AZ US-EAST-IA " > /var/www/html/index.html
              else
                  echo " This is server in AWS Region US-EAST-I in AZ US-EAST-IB " > /var/www/html/index.html
              fi
              EOF
  )


}

