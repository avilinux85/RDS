resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow inbound traffic for RDS"


  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = upper("allow_rds")
  }
}
