variable "private_subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "rds_security_group_id" {
  description = "Sec Group ID"
  type        = string
}
