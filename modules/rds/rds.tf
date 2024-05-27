resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "main"
  }
}

resource "aws_db_instance" "grafana_postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t2.micro"  # Free Tier eligible
  db_subnet_group_name = aws_db_subnet_group.default.name
  identifier           = "grafana"
  username             = "grafadmin"
  password             = "P@ssw0rd"  # Replace with a secure password
  parameter_group_name = "default.postgres12"
  skip_final_snapshot  = true

  tags = {
    Name = "grafana-postgres"
  }
}
