locals {
  subs = concat([data.aws_subnet.private_subnet_a.id], [data.aws_subnet.private_subnet_b.id])
  azs  = tolist(["a", "b"])

  hostn = tolist([var.this["hostname-a"], var.this["hostname-b"]])
}

resource "random_id" "this" {
  byte_length = 2
}

##############################
# Create EC2
##############################

resource "aws_instance" "this" {

  count = var.this["inst_count"]
  ami   = var.this["ami_id"]
  # ami                         = data.aws_ami.this.id
  instance_type               = var.this["inst_type"]
  subnet_id                   = element(local.subs, count.index)
  vpc_security_group_ids      = [data.aws_security_group.cmscloud_shared_services.id, aws_security_group.this.id]
  iam_instance_profile        = data.aws_iam_instance_profile.this.name
  associate_public_ip_address = false
  key_name                    = var.this["key_name"] #TODO: generate keys during creation and store in secrets manager
  user_data                   = base64encode(data.template_file.user_data.template)

  ebs_block_device {
    device_name = "/dev/xvda"
    encrypted   = true
  }

  tags = {
    Name          = "${random_id.this.id}-${element(local.azs, count.index)}"
    aws_backup    = "${var.this["backup"]}"
    "Patch Group" = "${var.this["patchgroup"]}"
    Terraform     = "true"
    hostname      = "${element(local.hostn, count.index)}"
  }
}

##############################
# Create Security Groups
##############################

resource "aws_security_group" "this" {
  description = "custom-security-sg"
  vpc_id      = data.aws_vpc.custom.id


  ingress = [
    {
      description      = "Inbound Rules"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [data.aws_subnet.private_a.cidr_block, data.aws_subnet.private_b.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "Outbound Rules"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name      = "custom-sg"
    terraform = "true"
  }
}


#######################################################################
# Attach EC2 to Target Groups of ELB - uncomment if Target Group Exists
#######################################################################

# resource "aws_lb_target_group_attachment" "_443" {
#   count            = var.this["inst_count"]
#   target_group_arn = data.aws_lb_target_group._443.arn
#   target_id        = aws_instance.this[count.index].id
#   port             = 443
# }
