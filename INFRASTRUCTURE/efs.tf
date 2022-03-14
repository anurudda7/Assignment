module "mount_target" {
  source    = "./custom-modules/efs/"
  subnet_id = "subnet-07dd0d28dbd14fd31"
}

