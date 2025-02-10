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

# This resource block defines an AWS subnet named "my_subneta".
# - `vpc_id`: The ID of the VPC where the subnet will be created.
# - `cidr_block`: The CIDR block for the subnet.
# - `map_public_ip_on_launch`: Whether to assign a public IP address to instances launched in this subnet.
# - `availability_zone`: The availability zone where the subnet will be created.
# - `tags`: A map of tags to assign to the subnet, with a "Name" tag set to "MySubneta".
resource "aws_subnet" "my_subneta" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "MySubneta"
  }
}


# This resource block defines an AWS subnet named "my_subnetb".
# It is associated with the VPC identified by aws_vpc.my_vpc.id.
# The subnet has a CIDR block of 10.0.2.0/24 and is configured to map public IPs on launch.
# It is located in the "us-east-1b" availability zone.
# The subnet is tagged with the name "MySubnetb".
resource "aws_subnet" "my_subnetb" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "MySubnetb"
  }
}


# Creates an AWS Internet Gateway and attaches it to the specified VPC.
# 
# Arguments:
# - vpc_id: The ID of the VPC to which the Internet Gateway will be attached.
# 
# Tags:
# - Name: A tag to identify the Internet Gateway with the value "MyInternetGateway".
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}


# Creates a route table for the specified VPC with a route to the internet gateway.
resource "aws_route_table" "my_route_table" {
  # The ID of the VPC.
  vpc_id = aws_vpc.my_vpc.id

  # A route that directs traffic destined for 0.0.0.0/0 to the internet gateway.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  # Tags to assign to the route table.
  tags = {
    Name = "MyRouteTable"
  }
}

# Associates the route table with the first subnet.
resource "aws_route_table_association" "my_rta_subneta" {
  # The ID of the subnet.
  subnet_id      = aws_subnet.my_subneta.id
  # The ID of the route table.
  route_table_id = aws_route_table.my_route_table.id
}

# Associates the route table with the second subnet.
resource "aws_route_table_association" "my_rta_subnetb" {
  # The ID of the subnet.
  subnet_id      = aws_subnet.my_subnetb.id
  # The ID of the route table.
  route_table_id = aws_route_table.my_route_table.id
}


