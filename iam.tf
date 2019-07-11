# ----------------------------
# FTP EC2 Instance Profile
# ----------------------------
resource "aws_iam_instance_profile" "ftp_instance_profile" {
  name = "${var.environment}_ftp_instance_profile"
  role = "${aws_iam_role.ftp_role.name}"
}

# ----------------
# FTP EC2 Role
# ----------------
resource "aws_iam_role" "ftp_role" {
  name = "${var.environment}_ftp_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# ---------------------------------
# Attach FTP Policy to Role
# ---------------------------------
resource "aws_iam_role_policy_attachment" "ftp_attach_ec2_policy" {
  role       = "${aws_iam_role.ftp_role.name}"
  policy_arn = "${aws_iam_policy.ftp_policy.arn}"
}

# ------------------
# FTP IAM Policy
# ------------------
resource "aws_iam_policy" "ftp_policy" {
  name        = "${var.environment}_ftp_policy"
  path        = "/"
  description = "${var.environment} FTP IAM Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "r53",
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
      ]
    },
    {
      "Sid": "s3",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.ftp.arn}/*"
      ]
    },
    {
       "Sid": "s3List",
       "Effect": "Allow",
       "Action": [
           "s3:ListBucketByTags",
           "s3:ListBucket",
           "s3:HeadBucket",
           "s3:ListAllMyBuckets"
       ],
       "Resource":[
          "*"
     ]
     },
   {
       "Sid": "ssmGetParam",
       "Effect": "Allow",
       "Action": [
           "ssm:GetParameter"
       ],
       "Resource":[
          "*"
     ]
     }
  ]
}
EOF
}

# ---------------------------------
# Attach AWS SSM IAM Policy to Role
# ---------------------------------
resource "aws_iam_role_policy_attachment" "ftp_attach_ssm_policy" {
  role       = "${aws_iam_role.ftp_role.name}"
  policy_arn = "${var.aws_ssm_iam_arn}"
}

# ---------------------------------
# Attach AWS IAM RO Policy to Role
# ---------------------------------
resource "aws_iam_role_policy_attachment" "ftp_attach_am_ro_policy" {
  role       = "${aws_iam_role.ftp_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

