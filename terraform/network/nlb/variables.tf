variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    region  = "us-east-1"
    lb_name = "demo-nlb-dev"
    lb_ip_a = "10.223.xx.xx"
    lb_ip_b = "10.223.xx.xx"
    env     = "dev"


  }
}
