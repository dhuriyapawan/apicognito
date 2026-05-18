resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "cloudguard-config-${random_id.suffix.hex}"

#   lifecycle {
#   prevent_destroy = true
#   ignore_changes = [
#     tags
#   ]
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}