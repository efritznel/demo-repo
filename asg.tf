# This resource block defines an AWS Launch Configuration named "demo-lc".
# The launch configuration specifies the following properties:
# - name: The name of the launch configuration.
# - image_id: The ID of the AMI to use for the instances.
# - instance_type: The type of instance to use (e.g., t2.micro).
# - security_groups: A list of security group IDs to associate with the instances.
# - key_name: The name of the key pair to use for SSH access to the instances.
#
# The lifecycle block ensures that the launch configuration is created before
# the old one is destroyed, which helps to avoid downtime during updates.
resource "aws_launch_configuration" "demo-lc" {
  name          = "demo-lc"
  image_id      = "ami-03d49b144f3ee2dc4"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.demo-sg.id]
  key_name="demo-key"

    lifecycle {
        create_before_destroy = true
    }
}

# This resource defines an AWS Auto Scaling Group named "demo-asg".
# It uses a launch configuration specified by the "aws_launch_configuration.demo-lc.name".
# The group will maintain a minimum of 1 instance and a maximum of 2 instances, with a desired capacity of 1 instance.
# Instances will be launched in the subnet identified by "aws_subnet.public.id".
# The Auto Scaling Group is associated with the target group identified by "aws_lb_target_group.app.arn".
# Health checks are performed using the Elastic Load Balancer (ELB) with a grace period of 300 seconds.
# Instances are terminated based on the "OldestInstance" policy.
# A tag with the key "Name" and value "demo-asg" is applied to instances at launch.
resource "aws_autoscaling_group" "demo-asg" {
  name = "demo-asg"
  launch_configuration = aws_launch_configuration.demo-lc.name
  min_size = 1
  max_size = 2
  desired_capacity = 1
  vpc_zone_identifier = [aws_subnet.public.id]
  target_group_arns = [aws_lb_target_group.app.arn]
  health_check_type = "ELB"
  health_check_grace_period = 300
  termination_policies = ["OldestInstance"]
  tag {
    key = "Name"
    value = "demo-asg"
    propagate_at_launch = true
  }
}