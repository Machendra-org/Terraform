#Creating user and attaching policy
resource "aws_iam_user" "machi-iam" {
    name = "machi-iam"
    path = "/system/"
    tags = {
        Name = "machi-iam"
    }
}
resource "aws_iam_access_key" "machi-iam" {
    user = aws_iam_user.machi-iam.id
}
resource "aws_iam_user_policy" "machi-policy" {
    name = "machi-policy"
    user = aws_iam_user.machi-iam.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
}
EOF
}
#Creating iam-Role
resource "aws_iam_role" "machi_role" {
  name = "machi-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_policy" "machi_policy" {
  name        = "machi-policy"
  description = "A test policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
#Creating iam-policy-attachment
resource "aws_iam_role_policy_attachment" "machi-attach" {
  role       = aws_iam_role.machi_role.id
  policy_arn = aws_iam_policy.machi_policy.arn
}
#Creating EC2 instance profile
resource "aws_iam_instance_profile" "machi_profile" {
  name = "machi-profile"
  role = "${aws_iam_role.machi_role.id}"
}
