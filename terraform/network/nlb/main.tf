##############################
# Create ELB
##############################

resource "aws_lb" "this" {
  name                             = var.this["lb_name"]
  internal                         = true
  enable_cross_zone_load_balancing = true
  load_balancer_type               = "network"


  subnet_mapping {
    subnet_id            = data.aws_subnet.public_a.id
    private_ipv4_address = var.this["lb_ip_a"]
  }

  subnet_mapping {
    subnet_id            = data.aws_subnet.public_b.id
    private_ipv4_address = var.this["lb_ip_b"]
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.this["env"]}"
    Name        = "${var.this["lb_name"]}"
  }
}

##############################
# Create Listeners
##############################

resource "aws_lb_listener" "_443" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group._443.arn
  }
}

##############################
# Create Target Groups
##############################

resource "aws_lb_target_group" "_443" {
  name     = "443"
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.custom.id

  stickiness {
    enabled = true
    type    = "source_ip"
  }

  health_check {
    port     = 443
    protocol = "TCP"
  }
}