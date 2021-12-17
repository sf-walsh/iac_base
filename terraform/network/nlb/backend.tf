# terraform {
#   backend "s3" {
#     bucket         = "tfstate-demobucket-acct"
#     key            = "demo_nlb/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "tf_locks"
#     encrypt        = true
#   }
# }