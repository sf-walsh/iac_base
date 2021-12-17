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

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "private"
  }
}

data "aws_subnet" "private_a" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-private-a"
  }
}

data "aws_subnet" "private_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-private-b"
  }
}

####################
## AMI Info / Instance Profile / Security Groups
####################

data "aws_ami" "this" {
  most_recent = true
  owners      = ["${var.this["ami_owner"]}"]

  filter {
    name   = "name"
    values = ["${var.this["ami_value"]}"]
  }
}


data "aws_iam_instance_profile" "this" {
  name = "demo-base-ec2-profile"
}

data "aws_security_group" "shared_services" {
  vpc_id = data.aws_vpc.custom.id
  name   = "shared-services"
}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/install_bins.sh.tpl")
}

# data "aws_lb_target_group" "_443" {
#   name = "443"
# }