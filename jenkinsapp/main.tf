# Provider AWS
provider "aws" {
  access_key = var.deployment6_access_key
  secret_key = var.deployment6_secret_key
  region     = var.deployment6_region1
}

# Jenkins Infra

# Instance 1 - Jenkins Manager (East)
resource "aws_instance" "jenkins-manager-east" {
  ami                         = var.deployment6_ami_east
  instance_type               = var.deployment6_instance_type_1
  subnet_id                   = "subnet-08c6d1915abdcff7d"
  vpc_security_group_ids      = [aws_security_group.deployment6_security_group_1.id]
  associate_public_ip_address = true
  key_name                    = var.deployment6_key_name
  user_data                   = file("jenkins.sh")
  tags = {
    Name = "jenkins-manager-east"
  }
}

# Instance 2 - Jenkins Agent (East)
resource "aws_instance" "jenkins-agent-east" {
  ami                         = var.deployment6_ami_east
  instance_type               = var.deployment6_instance_type_2
  subnet_id                   = "subnet-0da7607fbdc83a0fc"
  vpc_security_group_ids      = [aws_security_group.deployment6_security_group_1.id]
  key_name                    = var.deployment6_key_name
  associate_public_ip_address = true
  user_data                   = file("jenkins_agent.sh")
  tags = {
    Name = "jenkins-agent-east"
  }
}

# Security Group Block

resource "aws_security_group" "deployment6_security_group_1" {
  vpc_id = "vpc-0dd3eff4f5e677041"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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
