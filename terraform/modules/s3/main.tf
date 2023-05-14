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

resource "aws_s3_bucket_versioning" "file-versioning" {
  bucket = aws_s3_bucket.cloud_website.id
  versioning_configuration {
    status = "Enabled"
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
      "s3:GetObject"
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

resource "aws_s3_object" "html" {
  for_each = fileset("./resources/html/", "**/*.html")

  bucket = aws_s3_bucket.cloud_website.id
  key    = each.value
  source = "./resources/html/${each.value}"
  etag   = filemd5("./resources/html/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  for_each = fileset("./resources/css/", "**/*.css")

  bucket = aws_s3_bucket.cloud_website.id
  key    = each.value
  source = "./resources/css/${each.value}"
  etag   = filemd5("./resources/css/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  for_each = fileset("./resources/js/", "**/*.js")

  bucket = aws_s3_bucket.cloud_website.id
  key    = each.value
  source = "./resources/js/${each.value}"
  etag   = filemd5("./resources/js/${each.value}")
  content_type = "application/javascript"
}