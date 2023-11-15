# Provider AWS
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.deployment6_region1
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias  = "us-west-2"
  region = var.deployment6_region2
}

# VPC Block

resource "aws_vpc" "deployment6-vpc-east" {
  cidr_block       = var.deployment6_vpc_east_cidr
  instance_tenancy = "default"
  tags = {
    Name = "deployment6-vpc-east"
  }
}

resource "aws_vpc" "deployment6-vpc-west" {
  provider         = aws.us-west-2
  cidr_block       = var.deployment6_vpc_west_cidr
  instance_tenancy = "default"
  tags = {
    Name = "deployment6-vpc-west"
  }
}

# Subnet Block

# Subnet 1 - East
resource "aws_subnet" "publicSubnet01-east" {
  vpc_id                  = aws_vpc.deployment6-vpc-east.id
  cidr_block              = var.publicSubnet01_east_cidr
  availability_zone       = var.deployment6_az1_east
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSubnet01-east"
  }
}

# Subnet 2 - East
resource "aws_subnet" "publicSubnet02-east" {
  vpc_id                  = aws_vpc.deployment6-vpc-east.id
  cidr_block              = var.publicSubnet02_east_cidr
  availability_zone       = var.deployment6_az2_east
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSubnet02-east"
  }
}

# Subnet 3 - West
resource "aws_subnet" "publicSubnet01_west" {
  provider                = aws.us-west-2
  vpc_id                  = aws_vpc.deployment6-vpc-west.id
  cidr_block              = var.publicSubnet01_west_cidr
  availability_zone       = var.deployment6_az1_west
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSubnet01-west"
  }
}

# Subnet 4 - West
resource "aws_subnet" "publicSubnet02_west" {
  provider                = aws.us-west-2
  vpc_id                  = aws_vpc.deployment6-vpc-west.id
  cidr_block              = var.publicSubnet02_west_cidr
  availability_zone       = var.deployment6_az2_west
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSubnet02-west"
  }
}

# Internet Gateway Block

resource "aws_internet_gateway" "deployment6_internet_gateway1" {
  vpc_id = aws_vpc.deployment6-vpc-east.id
  tags = {
    Name = "deployment6_internet_gateway1"
  }
}

resource "aws_internet_gateway" "deployment6_internet_gateway2" {
  vpc_id = aws_vpc.deployment6-vpc-west.id
  tags = {
    Name = "deployment6_internet_gateway2"
  }
}

# Route Table Block

resource "aws_route_table" "deployment6_route_table1" {
  vpc_id = aws_vpc.deployment6-vpc-east.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.deployment6_internet_gateway1.id
  }
  tags = {
    Name = "deployment6_route_table1"
  }
}
resource "aws_route_table" "deployment6_route_table2" {
  vpc_id = aws_vpc.deployment6-vpc-west.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.deployment6_internet_gateway2.id
  }
  tags = {
    Name = "deployment6_route_table2"
  }
}
# Route Table Association

resource "aws_route_table_association" "deployment6_route_table_association_east1" {
  subnet_id      = aws_subnet.publicSubnet01-east.id
  route_table_id = aws_route_table.deployment6_route_table1.id
}
resource "aws_route_table_association" "deployment6_route_table_association_east2" {
  subnet_id      = aws_subnet.publicSubnet02-east.id
  route_table_id = aws_route_table.deployment6_route_table1.id
}

resource "aws_route_table_association" "deployment6_route_table_association_west1" {
  subnet_id      = aws_subnet.publicSubnet01_west.id
  route_table_id = aws_route_table.deployment6_route_table2.id
}
resource "aws_route_table_association" "deployment6_route_table_association_west2" {
  subnet_id      = aws_subnet.publicSubnet02_west.id
  route_table_id = aws_route_table.deployment6_route_table2.id
}

# Instance 1 - App (East)

resource "aws_instance" "east-application1" {
  ami                         = var.deployment6_ami_east
  instance_type               = var.deployment6_instance_type_1
  subnet_id                   = aws_subnet.publicSubnet01-east.id
  vpc_security_group_ids      = [aws_security_group.deployment6_security_group_1.id]
  associate_public_ip_address = true
  user_data                   = file("app.sh")
  tags = {
    Name = "jenkins-manager-east"
  }
}

# Instance 2 - App (East)
resource "aws_instance" "east-application2" {
  ami                         = var.deployment6_ami_east
  instance_type               = var.deployment6_instance_type_2
  subnet_id                   = aws_subnet.publicSubnet02-east.id
  vpc_security_group_ids      = [aws_security_group.deployment6_security_group_1.id]
  associate_public_ip_address = true
  user_data                   = file("app.sh")
  tags = {
    Name = "jenkins-agent-east"
  }
}

# Instance 1 - App (West)

resource "aws_instance" "west-application1" {
  ami                         = var.deployment6_ami_west
  instance_type               = var.deployment6_instance_type_1
  subnet_id                   = aws_subnet.publicSubnet01_west.id
  vpc_security_group_ids      = [aws_security_group.deployment6_security_group_2.id]
  associate_public_ip_address = true
  user_data                   = file("app.sh")
  tags = {
    Name = "jenkins-manager-west"
  }
}

# Instance 2 - App (West)
resource "aws_instance" "west-application2" {
  ami                         = var.deployment6_ami_west
  instance_type               = var.deployment6_instance_type_2
  subnet_id                   = aws_subnet.publicSubnet02_west.id
  vpc_security_group_ids      = [aws_security_group.deployment6_security_group_2.id]
  associate_public_ip_address = true
  user_data                   = file("app.sh")
  tags = {
    Name = "jenkins-agent-west"
  }
}

# Security Group Block

resource "aws_security_group" "deployment6_security_group_1" {
  vpc_id = aws_vpc.deployment6-vpc-east.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "deployment6_security_group_2" {
  vpc_id = aws_vpc.deployment6-vpc-west.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
