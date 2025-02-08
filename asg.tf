# Create Launch Template
resource "aws_launch_template" "my_template" {
  name_prefix   = "my-template"
  image_id      = "ami-03d49b144f3ee2dc4"  # Replace with latest Amazon Linux AMI
  instance_type = "t2.micro"
  key_name      = "demo-key"  # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.my_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "AutoScalingInstance"
    }
  }
  
  lifecycle {
        create_before_destroy = true
    }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  desired_capacity     = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.my_subnet.id]

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.my_tg.arn]

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }
}