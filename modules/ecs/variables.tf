variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS Endpoint"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB Listener ARN"
  type        = string
}
