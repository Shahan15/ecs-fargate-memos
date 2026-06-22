resource "aws_s3_bucket" "tf_state_s3" {
  bucket        = "shahan-memos-tf-state-bucket"
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
