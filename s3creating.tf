resource "aws_s3_bucket" "b1" {
  bucket = "my-machi-test-bucket"

  tags = {
    Name = "machi-7013"
  }
}

resource "aws_s3_bucket_acl" "acl-public" {
  bucket = "${aws_s3_bucket.b1.id}"
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = "${aws_s3_bucket.b1.id}"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "my-object" {
  //for_each = fileset("https://github.com/Machendra2/Local-repo-git/blob/0c0a55deb562631f4da3a1dd819f29e69ae39d41/Task%201/pic1.png/", "*")
  bucket = "my-machi-test-bucket"
  acl    = "public-read"
  key    = "pic1.png"
  source = "/home/ubuntu/terraform2/Local-repo-git/Task 1/pic1.png"
  //source = "https://github.com/Machendra2/Local-repo-git/blob/0c0a55deb562631f4da3a1dd819f29e69ae39d41/Task%201/pic1.png/${each.value}" 
}

resource "aws_s3_object" "my-object-1" {
  bucket = "my-machi-test-bucket"
  acl    = "public-read"
  key    = "pic2.png"
  source = "/home/ubuntu/terraform2/Local-repo-git/Task 1/pic2.png"

}

###################################
# S3 Bucket Policy
###################################
resource "aws_s3_bucket_policy" "read_gitbook" {
  bucket = aws_s3_bucket.b1.id
  policy = data.aws_iam_policy_document.read_gitbook_bucket.json
}

###################################
# S3 Bucket Public Access Block
###################################
resource "aws_s3_bucket_public_access_block" "gitbook" {
  bucket = aws_s3_bucket.b1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}

###################################
# IAM Policy Document
###################################
data "aws_iam_policy_document" "read_gitbook_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.b1.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.gitbook-b1.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.b1.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.gitbook-b1.iam_arn]
    }
  }
}

###################################
# CloudFront Origin Access Identity
###################################
resource "aws_cloudfront_origin_access_identity" "gitbook-b1" {
  comment = "gitbook-b1"
}

locals {
  s3_origin_id = "myS3Origin"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.b1.bucket}.s3.amazonaws.com"
    origin_id   = "${local.s3_origin_id}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.gitbook-b1.cloudfront_access_identity_path}"
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

# Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

# Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
     # locations        = ["US", "CA", "GB", "DE"]
    }
  }
  tags = {
    Environment = "production"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
