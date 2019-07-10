# ---------------------------------------
# s3 Bucket
# ---------------------------------------
resource "aws_s3_bucket" "ftp" {
  bucket_prefix = "${var.environment}-ftp-"
  acl           = "private"

  versioning {
    enabled = "true"
  }

  tags = {
    Environment   = "${var.environment}"
    orchestration = "${var.orchestration}"
    purpose       = "${var.environment}-ftp-s3-data"
  }
}
