resource "aws_cloudwatch_log_group" "grafana_log_group" {
  name              = "/ecs/grafana"
  retention_in_days = 1
}
