#Creating S3-bucket
resource "aws_s3_bucket" "bucket-tf" {
  bucket = "my-tf-test-bucket-machi"

  tags = {
    Name        = "my-tf-bucket"
  }
}

resource "aws_s3_bucket_acl" "tf-machi" {
  bucket = aws_s3_bucket.bucket-tf.id
  acl    = "private"
}
#Attaching Iam-policy to the S3-bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.bucket-tf.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.machi-iam.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.bucket-tf.arn}",
        "${aws_s3_bucket.bucket-tf.arn}/*"
      ]
    }
  ]
}
EOF
}
