variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    region     = "us-east-1"
    inst_count = "1"
    inst_type  = "m5.xlarge"
    key_name   = "ssh-key-pair"
    backup     = "7daily"
    patchgroup = "Critical"
    hostname-a = "demo-host-a"
    hostname-b = "demo-host-b"
    ami_owner  = "01234567890"          #Owner of the private AMI being used
    ami_value  = "amzn2-goldimage-*"  #AMI Name being shared
    ami_id     = "ami-0ed9277fb7eb570c9" #Marketplace AMI - to use comment/uncomment ami line in main.tf
  }
}
