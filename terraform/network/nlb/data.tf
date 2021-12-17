#####################
### Account Information
#####################

data "aws_caller_identity" "current" {}

#####################
### VPC and Roles
#####################

data "aws_vpc" "custom" {
  default = false
}

#####################
### Availability Zones and Subnets
#####################

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet" "public_a" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-public-a"
  }
}

data "aws_subnet" "public_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-public-b"
  }
}