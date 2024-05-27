resource "aws_db_instance" "grafana_postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t2.micro"  # Free Tier eligible
  name                 = "grafana"
  username             = "admin"
  password             = "yourpassword"  # Replace with a secure password
  parameter_group_name = "default.postgres12"
  skip_final_snapshot  = true

  tags = {
    Name = "grafana-postgres"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.grafana_postgres.endpoint
}
