resource "aws_ecs_cluster" "grafana_cluster" {
  name = "grafana-cluster"
}

resource "aws_ecs_task_definition" "grafana_task" {
  family                   = "grafana-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  
  container_definitions = jsonencode([{
    name      = "grafana"
    image     = "grafana/grafana:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
    environment = [
      {
        name  = "GF_DATABASE_TYPE"
        value = "postgres"
      },
      {
        name  = "GF_DATABASE_HOST"
        value = module.rds.rds_endpoint
      },
      {
        name  = "GF_DATABASE_USER"
        value = "admin"
      },
      {
        name  = "GF_DATABASE_PASSWORD"
        value = "yourpassword"  # Same password as RDS instance
      },
      {
        name  = "GF_DATABASE_NAME"
        value = "grafana"
      }
    ]
  }])
}

resource "aws_ecs_service" "grafana_service" {
  name            = "grafana-service"
  cluster         = aws_ecs_cluster.grafana_cluster.id
  task_definition = aws_ecs_task_definition.grafana_task.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public.*.id
    security_groups  = [aws_security_group.grafana_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grafana_tg.arn
    container_name   = "grafana"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.grafana_listener]
}
