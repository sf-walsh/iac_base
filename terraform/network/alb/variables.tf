variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    region     = "us-east-1"
    lb_name    = "demo-alb-dev"
    lb_ip_a    = "10.0.1.10"
    lb_ip_b    = "10.0.2.10"
    env        = "dev"
    certdomain = "echimpdev.com"


  }
}
