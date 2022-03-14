module "jump_server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v4.8.0"

  name        = "jump-server-sg"
  description = "Security group for user-service with custom ports open within UserGW IP, and jump server"
  vpc_id      = module.vpc.vpc_id
 
   ingress_with_cidr_blocks = [  
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "open ssh to user"
      cidr_blocks = "119.235.9.8/29"
    },
        {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "open ssh to user"
      cidr_blocks = "203.189.69.64/28"
    },
        {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "open ssh to user"
      cidr_blocks = "203.115.26.136/29"
    },
        {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "open ssh to user"
      cidr_blocks = "112.134.128.34/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "open ssh to user"
      cidr_blocks = "3.111.128.131/32"
    },
  ] 
  egress_with_cidr_blocks = [
  {
    rule        = "https-443-tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "open nfs access"
      cidr_blocks = "10.10.0.0/16"
    },

]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["http-80-tcp"]


}



resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "jump-key"
  public_key = tls_private_key.this.public_key_openssh
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "v3.4.0"

  name = "jump-instance"

  ami                    = "ami-0c174998c62d71b71"
  instance_type          = "t2.micro"
  key_name               = "jump-key"
  monitoring             = true
  vpc_security_group_ids = [module.jump_server_sg.security_group_id]
  subnet_id              = "subnet-0eb22a1e0208d71d7"

  tags = {
    Terraform   = "true"
    Resource    = "ec2"
    Owner       = "sampath"
    Environment = "demo"
  }
}
