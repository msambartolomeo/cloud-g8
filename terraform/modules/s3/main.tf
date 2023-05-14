resource "aws_s3_bucket" "cloud_website" {
  bucket = "www.${var.bucket_name}"

  tags = { Project : "websites" }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.cloud_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid = "PublicReadGetObject"
    principals {
      type="AWS"
      identifiers=["arn:aws:iam::${var.account_id}:role/LabRole"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.cloud_website.arn,
      "${aws_s3_bucket.cloud_website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.cloud_website.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}