data "aws_ami" "amimumbai" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "test" {
  ami                    = data.aws_ami.amimumbai.id
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2-intance-profile.name
  vpc_security_group_ids = [aws_security_group.allow_rds.id]
  tags = {
    Name = upper("test_ec2")
  }
}
