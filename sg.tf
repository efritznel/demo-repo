# This Terraform configuration defines an AWS Security Group resource named "demo-sg".
# The security group allows inbound traffic on port 80 (HTTP) from any IP address (0.0.0.0/0).
# 
# Arguments:
# - name: The name of the security group.
# - description: A description of the security group.
# - vpc_id: The ID of the VPC where the security group will be created.
#
# Ingress Rules:
# - from_port: The starting port for the allowed inbound traffic (80).
# - to_port: The ending port for the allowed inbound traffic (80).
# - protocol: The protocol for the allowed inbound traffic (tcp).
# - cidr_blocks: The CIDR blocks from which inbound traffic is allowed (["0.0.0.0/0"]).
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow inbound traffic on port 80"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}
