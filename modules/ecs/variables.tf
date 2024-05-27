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
