resource "aws_iam_role" "GeoCit_Role" {
  name = local.iam_role_name
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

resource "aws_iam_policy" "policy" {
  name   = "RDSAndS3FullAcess"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*",
                "rds:*"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = local.iam_policy_att_name
  roles      = ["${aws_iam_role.GeoCit_Role.name}"]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "geocit_profile" {
  name = local.iam_instance_profile_name
  role = aws_iam_role.GeoCit_Role.name
}
