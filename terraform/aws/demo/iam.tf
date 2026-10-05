# One role for the whole box. On EKS each service had its own Pod Identity role scoped to its own
# prefix (../dev/roles.tf). Here every container shares the instance's credentials, so this role is
# the union of those three policies. Containers reach them through IMDS (see metadata_options in ec2.tf).

data "aws_s3_bucket" "app" {
  bucket = var.app_bucket_name
}

resource "aws_iam_role" "demo" {
  name = "viscord-demo-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "app_bucket" {
  name = "app-bucket"
  role = aws_iam_role.demo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [data.aws_s3_bucket.app.arn]
      },
      {
        # default avatars
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["${data.aws_s3_bucket.app.arn}/assets/*"]
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = [
          "${data.aws_s3_bucket.app.arn}/avatars/*",              # user-service
          "${data.aws_s3_bucket.app.arn}/icons/*",                # guild-service
          "${data.aws_s3_bucket.app.arn}/messages/attachments/*", # message-service
        ]
      }
    ]
  })
}

# Shell access through SSM Session Manager (`aws ssm start-session`): no SSH key or open port 22 needed,
# and sessions are authenticated with IAM.
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "demo" {
  name = "viscord-demo-ec2"
  role = aws_iam_role.demo.name
}
