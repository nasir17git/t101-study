# backend 생성 (S3버킷, DynamoDB)
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "nasir_s3" {
  bucket = "nasir-week3"
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.nasir_s3.id

  versioning_configuration {
    status = "Enabled"
  }
} 

resource "aws_dynamodb_table" "s3_lock" {
  name         = "s3_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}