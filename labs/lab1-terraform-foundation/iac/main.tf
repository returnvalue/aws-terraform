resource "aws_vpc" "portfolio_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Portfolio-VPC" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "Portfolio-Public-Subnet" }
}
