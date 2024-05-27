output "security_group_id" {
  value = aws_security_group.grafana_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.grafana_tg.arn
}

output "alb_arn" {
  value = aws_lb.grafana_lb.arn
}
