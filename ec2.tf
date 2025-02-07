# This Terraform configuration defines an AWS EC2 instance resource.
# 
# Resource: aws_instance "demo-ec2"
# 
# Parameters:
# - ami: The ID of the Amazon Machine Image (AMI) to use for the instance.
# - instance_type: The type of instance to start (e.g., t2.micro).
# - subnet_id: The ID of the subnet to launch the instance in.
# - key_name: The name of the key pair to use for SSH access to the instance.
# - tags: A map of tags to assign to the instance. In this case, it assigns the tag "Name" with the value "web-server".
resource "aws_instance" "demo-ec2" {
  ami           = "ami-03d49b144f3ee2dc4"
  instance_type = "t2.micro"
    subnet_id     = aws_subnet.publica.id
    key_name="demo-key"
    tags = {
        Name = "web-server"
    }

}
