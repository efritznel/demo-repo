# This resource block defines an AWS VPC (Virtual Private Cloud) with the following properties:
# - `cidr_block`: The CIDR block for the VPC, set to "10.0.0.0/16".
# - `enable_dns_support`: Enables DNS resolution for the VPC, set to true.
# - `enable_dns_hostnames`: Enables DNS hostnames for instances within the VPC, set to true.
# - `tags`: A map of tags to assign to the VPC, with a single tag "Name" set to "MyVPC".
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Create Subnet A
resource "aws_subnet" "my_subneta" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "MySubneta"
  }
}

# Create Subnet B
resource "aws_subnet" "my_subnetb" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "MySubnetb"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Create Route Table and Route
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "my_rta_subneta" {
  subnet_id      = aws_subnet.my_subneta.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_rta_subnetb" {
  subnet_id      = aws_subnet.my_subnetb.id
  route_table_id = aws_route_table.my_route_table.id
}


