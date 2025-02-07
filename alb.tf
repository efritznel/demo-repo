# This resource creates an AWS Application Load Balancer (ALB) named "demo-alb".
# The ALB is internet-facing (internal = false) and uses the "application" load balancer type.
# It is associated with the security group defined by aws_security_group.demo-sg.id.
# The ALB is deployed in the subnet defined by aws_subnet.public.id.
# The ALB is tagged with the name "demo-alb".
resource "aws_alb" "app" {
  name            = "demo-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.demo-sg.id]
  subnets         = [aws_subnet.public.id]
  tags = {
    Name = "demo-alb"
  }
}

# This resource block defines an AWS Load Balancer Target Group named "app".
# The target group is named "demo-tg" and listens on port 80 using the HTTP protocol.
# It is associated with the VPC identified by the ID of the "aws_vpc.main" resource.
resource "aws_lb_target_group" "app" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Creates an AWS Application Load Balancer (ALB) listener for the front-end.
# The listener listens on port 80 using the HTTP protocol.
# It forwards incoming traffic to the specified target group.
# 
# Arguments:
# - load_balancer_arn: The ARN of the ALB to associate with the listener.
# - port: The port on which the listener will accept traffic (80 for HTTP).
# - protocol: The protocol for connections from clients to the load balancer (HTTP).
# - default_action: The action to take when a request matches the listener.
#   - type: The type of action (forward).
#   - target_group_arn: The ARN of the target group to forward traffic to.
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
