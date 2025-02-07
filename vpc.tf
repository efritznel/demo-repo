# This resource block defines an AWS VPC (Virtual Private Cloud) named "main".
# The VPC has a CIDR block of 11.0.0.0/16, which specifies the IP address range for the VPC.
# The VPC is tagged with the name "demo-vpc" for identification purposes.
resource "aws_vpc" "main" {
  cidr_block = "11.0.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

# Creates a public subnet within the specified VPC.
# 
# Arguments:
#   vpc_id: The ID of the VPC where the subnet will be created.
#   cidr_block: The CIDR block for the subnet.
#   tags: A map of tags to assign to the subnet.
# 
resource "aws_subnet" "publica" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "11.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "publica-subnet"
    }
}

resource "aws_subnet" "publicb" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "11.0.3.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "publicb-subnet"
    }
}

# This resource block defines a private subnet within a specified VPC.
# - `vpc_id`: The ID of the VPC where the subnet will be created.
# - `cidr_block`: The CIDR block for the subnet.
# - `tags`: A map of tags to assign to the subnet, in this case, naming it "private-subnet".
resource "aws_subnet" "privatea" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "11.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "privatea-subnet"
    }
}

resource "aws_subnet" "privateb" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "11.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "privateb-subnet"
    }
}

# Creates an AWS Internet Gateway and attaches it to the specified VPC.
# 
# Arguments:
#   vpc_id - The ID of the VPC to which the Internet Gateway will be attached.
#   tags - A map of tags to assign to the resource. In this case, it assigns the tag "Name" with the value "demo-gw".
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "demo-gw"
    }
}

# Creates a public route table for the specified VPC.
# 
# Arguments:
#   vpc_id: The ID of the VPC where the route table will be created.
# 
# Route:
#   cidr_block: The destination CIDR block for the route.
#   gateway_id: The ID of the internet gateway to route traffic to.
# 
# Tags:
#   Name: A name tag for the route table.
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "public-route-table"
    }   
}

# Associates a subnet with a route table to define the routing rules for the subnet.
# 
# Arguments:
#   subnet_id: The ID of the subnet to associate with the route table.
#   route_table_id: The ID of the route table to associate with the subnet.
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}



