# This resource block defines an AWS Launch Template named "my_template".
# The launch template is configured with the following parameters:
# - name_prefix: Prefix for the launch template name.
# - image_id: The ID of the AMI to use for the instances (replace with the latest Amazon Linux AMI).
# - instance_type: The type of instance to launch (t2.micro in this case).
# - key_name: The name of the key pair to use for SSH access (replace with your key pair name).
#
# The network_interfaces block configures the network settings:
# - associate_public_ip_address: Associates a public IP address with the instance.
# - security_groups: Specifies the security group to associate with the instance.
#
# The user_data block contains a base64-encoded script that runs on instance launch:
# - Writes a message to /var/www/html/index.html.
# - Installs and starts the Apache HTTP server.
#
# The tag_specifications block adds tags to the instances created from this launch template:
# - resource_type: Specifies that the tags apply to instances.
# - tags: A map of tags to apply (e.g., Name = "AutoScalingInstance").
#
# The lifecycle block ensures that the launch template is created before any existing one is destroyed:
# - create_before_destroy: Ensures the new resource is created before the old one is destroyed.
resource "aws_launch_template" "my_template" {
  name_prefix   = "my-template"
  image_id      = "ami-085ad6ae776d8f09c"  # Replace with latest Amazon Linux AMI
  instance_type = "t2.micro"
  key_name      = "demokeypair"  # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Projetct: How to deploy a High Availability web application on AWS!" > /var/www/html/index.html
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

# This Terraform configuration creates an AWS Auto Scaling Group (ASG) with the following properties:
# - desired_capacity: The initial number of instances in the ASG.
# - min_size: The minimum number of instances in the ASG.
# - max_size: The maximum number of instances in the ASG.
# - vpc_zone_identifier: A list of subnet IDs where the ASG will launch instances.
# - launch_template: Specifies the launch template to use for the instances, including the template ID and version.
# - target_group_arns: A list of target group ARNs to associate with the ASG.
# - tag: A tag to apply to the instances launched by the ASG, with the key "Name" and value "ASG-Instance", propagated at launch.
# Create Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  desired_capacity     = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.my_subneta.id, aws_subnet.my_subnetb.id]

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