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
  instance_class       = "db.t3.micro"  # Free Tier eligible
  db_subnet_group_name = aws_db_subnet_group.default.name
  identifier           = "grafana"
  username             = "grafadmin"
  password             = "password"  # Replace with a secure password
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  tags = {
    Name = "grafana-postgres"
  }
}
