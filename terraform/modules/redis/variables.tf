variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "engine_version" {
  type    = string
  default = "7.1"
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "port" {
  type    = number
  default = 6379
}

variable "num_cache_nodes" {
  type    = number
  default = 2
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "automatic_failover" {
  type    = bool
  default = true
}

variable "parameter_group_name" {
  type    = string
  default = "default.redis7"
}

variable "snapshot_retention_limit" {
  type    = number
  default = 7
}

variable "snapshot_window" {
  type    = string
  default = "03:00-05:00"
}

variable "allowed_security_group_ids" {
  type = list(string)
}