
locals {
  region = "ap-south-1"
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
#   providers = {
#   aws = aws.aws-primary
# }
  source = "./custom-modules/vpc/"

  name = "demo-stage-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24"]

 
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    Name = "demo-stage-public"  }

  tags = {
        Resource    = "vpc"
        Owner       = "sampath"
        Environment = "demo"
  }

  vpc_tags = {
    Name = "demo-vpc"
  }
}