##################################################################################################
## Creating an Role for Secret Manager,S3 Full Access and SSM Access for EC2 Instance
resource "aws_iam_role" "terraform_role" {
  name = "TERRAFORM_ADMIN_ROLE"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

###########################################################################################################
### Attaching the role with AWS Managed Policy for Secrets Manager Read Write Amazon SSM Full Access and S3 Full Access#######
resource "aws_iam_role_policy_attachment" "terraform_role_attachement" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
  role       = aws_iam_role.terraform_role.name
  policy_arn = each.value
}

##### Creating an Instance profile associated with ROLE
resource "aws_iam_instance_profile" "ec2-intance-profile" {
  name = "Terraform_POC"
  role = aws_iam_role.terraform_role.name
}
