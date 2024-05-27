output "rds_endpoint" {
  value = aws_db_instance.grafana_postgres.endpoint
}
