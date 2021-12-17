#####################
### Account Information
#####################

data "aws_caller_identity" "current" {}

#####################
### VPC and Roles
#####################

data "aws_vpc" "custom" {
  default = false
  id      = "vpc-0fa70299b0f3c5f1d"
}

#####################
### Availability Zones and Subnets
#####################

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "private"
  }
}
data "aws_subnet" "private_a" {
  vpc_id = data.aws_vpc.custom.id
  id     = "subnet-0a5eed221c9a9b92e"
}

data "aws_subnet" "private_b" {
  vpc_id = data.aws_vpc.custom.id
  id     = "subnet-070ef88fc259194a7"
}


data "aws_lb_target_group" "_443" {
  name = "443"
}

#####################
### Availability Zones and Subnets
#####################

data "aws_acm_certificate" "this" {
  domain = var.this["certdomain"]
}