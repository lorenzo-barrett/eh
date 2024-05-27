provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

resource "aws_rds_cluster" "aurora_postgres" {
  cluster_identifier      = "aurora-postgres-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "12.6"
  database_name           = "grafana"
  master_username         = "grafadmin"
  master_password         = "P@ssw0rd"  # Replace with a secure password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true

  scaling_configuration {
    auto_pause   = true
    min_capacity = 2
    max_capacity = 8
    seconds_until_auto_pause = 300
  }

  tags = {
    Name = "aurora-postgres-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_postgres_instance" {
  count              = 1
  identifier         = "aurora-postgres-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_postgres.id
  instance_class     = "db.t2.micro"
  engine             = aws_rds_cluster.aurora_postgres.engine
  engine_version     = aws_rds_cluster.aurora_postgres.engine_version

  tags = {
    Name = "aurora-postgres-instance-${count.index}"
  }
}

output "rds_endpoint" {
  value = aws_rds_cluster.aurora_postgres.endpoint
}
