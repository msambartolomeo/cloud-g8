output "s3_bucket" {
  value = {
    tags   = aws_s3_bucket.cloud_website.tags
    id     = aws_s3_bucket.cloud_website.id
    arn    = aws_s3_bucket.cloud_website.arn
    region = aws_s3_bucket.cloud_website.region
  }
}