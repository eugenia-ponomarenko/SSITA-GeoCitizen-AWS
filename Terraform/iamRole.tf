resource "aws_iam_role" "geocit_accessToRDS" {
  name = "GeoCitizen-AccessToRDS"
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

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "policy_attachment"
  roles      = ["${aws_iam_role.geocit_accessToRDS.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_instance_profile" "geocit_profile" {
  name = "geoCitizen"
  role = aws_iam_role.geocit_accessToRDS.name
}
