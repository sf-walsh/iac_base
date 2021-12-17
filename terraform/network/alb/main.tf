##############################
# Create ELB
##############################

resource "aws_lb" "this" {
  name                             = var.this["lb_name"]
  internal                         = true
  enable_cross_zone_load_balancing = true

  load_balancer_type = "application"


  subnet_mapping {
    subnet_id = data.aws_subnet.private_a.id
  }

  subnet_mapping {
    subnet_id = data.aws_subnet.private_b.id
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
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group._25494.arn
  }
}

# ##############################
# # Create Listener Rule
# ##############################

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener._443.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group._80.arn
  }

  condition {
    path_pattern {
      values = ["/rest/v2/*"]
    }
  }
}

# ##############################
# # Create Target Groups
# ##############################

resource "aws_lb_target_group" "_80" {
  name     = "80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.custom.id

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled     = true
    type        = "app_cookie"
    cookie_name = "SESSIONID"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "_443" {
  target_group_arn = data.aws_lb_target_group._443.arn
  target_id        = aws_lb.this.arn
  port             = 443
}
