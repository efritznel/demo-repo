# This resource defines an AWS Security Group named "lb_sg" within the specified VPC.
# It allows inbound HTTP traffic (port 80) from any IP address (0.0.0.0/0).
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}


# This resource defines an AWS Security Group named "instance_sg".
# It is associated with a VPC identified by the ID of "aws_vpc.my_vpc".
#
# Ingress Rules:
# - Allows incoming TCP traffic on port 80 from the security group identified by "aws_security_group.lb_sg.id".
#
# Egress Rules:
# - Allows all outbound traffic (all protocols, all ports) to any destination (0.0.0.0/0).
#
# Tags:
# - Name: "instance-sg"
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}
