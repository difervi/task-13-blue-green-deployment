
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-uad9vkoz-vpc"]
  }
}
data "aws_subnets" "public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-uad9vkoz-public-subnet1"]
  }
}
data "aws_subnets" "public_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-uad9vkoz-public-subnet2"]
  }
}
data "aws_security_group" "SSH_access" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-uad9vkoz-sg-ssh"]
  }
}
data "aws_security_group" "HTTP_access_to_EC2" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-uad9vkoz-sg-http"]
  }
}
data "aws_security_group" "HTTP_access_to_ALB" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-uad9vkoz-sg-lb"]
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}