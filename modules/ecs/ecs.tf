resource "aws_ecs_cluster" "grafana_cluster" {
  name = "grafana-cluster"
}

resource "aws_ecs_task_definition" "grafana_task" {
  family                   = "grafana-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
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
        value = var.rds_endpoint
      },
      {
        name  = "GF_DATABASE_USER"
        value = "grafadmin"
      },
      {
        name  = "GF_DATABASE_PASSWORD"
        value = "password"  # Same password as RDS instance
      },
      {
        name  = "GF_DATABASE_NAME"
        value = "grafana"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/grafana"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "grafana_service" {
  name            = "grafana-service"
  cluster         = aws_ecs_cluster.grafana_cluster.id
  task_definition = aws_ecs_task_definition.grafana_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true  # Set to true to assign public IP to the Fargate task
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "grafana"
    container_port   = 3000
  }

  depends_on = [var.alb_listener_arn]
}
