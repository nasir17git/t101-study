output "s3_bucket_arn" {
  value       = aws_s3_bucket.nasir_s3.arn
  description = "s3 bucket arn"
}

output "ddb_tablename" {
  value       = aws_dynamodb_table.s3_lock.name
  description = "ddb name"
}