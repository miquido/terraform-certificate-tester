variable "project" {
  type        = string
  description = "Account/Project Name"
}

variable "environment" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "log_retention" {
  type        = number
  description = "How long should logs be retained"
  default     = 30
}

variable "schedule_expression" {
  type        = string
  default     = "cron(0 0 * * ? *)"
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes)."
}

variable "domain" {
  type        = string
  description = "Domain to check certificate validity"
}