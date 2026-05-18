resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.project_name}-config-buckets"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}