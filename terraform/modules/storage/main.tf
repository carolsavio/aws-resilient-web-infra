resource "aws_s3_bucket" "backup" {
  bucket_prefix = lower("${var.project_name}-backups-")
  tags = { Name = "${var.project_name}-Backup-Bucket" }
}