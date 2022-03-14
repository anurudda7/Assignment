resource "aws_efs_file_system" "efs" {
  creation_token = var.token
    /* lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  } */

tags = var.tags

}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs.id

  subnet_id      = var.subnet_id
}

/* resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs.id
} */


