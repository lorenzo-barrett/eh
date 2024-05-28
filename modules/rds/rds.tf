resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "main"
  }
}

resource "aws_db_parameter_group" "custom_postgres" {
  name        = "custom-postgres13"
  family      = "postgres13"
  description = "Custom parameter group for PostgreSQL 13"

  parameter {
    name  = "max_connections"
    value = "100"
    apply_method = "pending-reboot"  # Use pending-reboot for static parameters
  }
}

resource "aws_db_instance" "grafana_postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"  # Free Tier eligible
  db_subnet_group_name = aws_db_subnet_group.default.name
  identifier           = "grafana"
  username             = "grafadmin"
  password             = "password"  # Replace with a secure password
  parameter_group_name = aws_db_parameter_group.custom_postgres.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot  = true

  tags = {
    Name = "grafana-postgres"
  }
}
