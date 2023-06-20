resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Creating a AWS secret for database master account (Masteraccoundb)
resource "aws_secretsmanager_secret" "secretmasterDB" {
  name = "Masteraccoundb_POCnew"
}

# Creating a AWS secret versions for database master account (Masteraccoundb)

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
   {
    "username": "adminaccount",
    "password": "${random_password.password.result}"
   }
EOF
}

# Importing the AWS secrets created previously using arn.

data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.secretmasterDB.arn
}

# Importing the AWS secret version created previously using arn.

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn
}

# After importing the secrets storing into Locals

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}


resource "aws_db_subnet_group" "RDS_SUBNET" {
  name = "rds_subnet_group"
  subnet_ids = [
    "subnet-03ae31dbf58c2c3b0",
    "subnet-0e146667ac8ddebaf"
  ]

  tags = {
    Name = "RDS_SUBNET_GROUP"
  }
}

###CREATE AN RDS DB INSTANCE
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb_poc"
  db_subnet_group_name   = aws_db_subnet_group.RDS_SUBNET.id
  vpc_security_group_ids = ["${aws_security_group.allow_rds.id}"]
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = local.db_creds.username
  password               = local.db_creds.password
  port                   = 3306
  skip_final_snapshot    = true
}
