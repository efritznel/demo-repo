# This resource block defines an AWS Application Load Balancer (ALB).
# 
# Arguments:
# - name: The name of the load balancer.
# - internal: Boolean indicating whether the load balancer is internal.
# - load_balancer_type: The type of load balancer to create. In this case, it's an "application" load balancer.
# - security_groups: A list of security group IDs to associate with the load balancer.
# - subnets: A list of subnet IDs to attach to the load balancer.
# 
# Tags:
# - Name: A tag to identify the load balancer.
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets           = [aws_subnet.my_subneta.id, aws_subnet.my_subnetb.id]

  tags = {
    Name = "MyLoadBalancer"
  }
}


# Creates an AWS Load Balancer Target Group
# - name: The name of the target group
# - port: The port on which the targets receive traffic
# - protocol: The protocol to use for routing traffic to the targets
# - vpc_id: The ID of the VPC in which to create the target group
resource "aws_lb_target_group" "my_tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}


# This resource defines an AWS Load Balancer Listener.
# It listens on port 80 using the HTTP protocol.
# The listener is associated with the specified load balancer (aws_lb.my_lb).
# The default action for the listener is to forward requests to the specified target group (aws_lb_target_group.my_tg).
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}