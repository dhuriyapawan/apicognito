# resource "aws_elasticache_subnet_group" "this" {
#   name       = "${var.name}-subnet-group"
#   subnet_ids = var.private_subnet_ids

#   tags = {
#     Name        = "${var.name}-subnet-group"
#     Environment = var.environment
#   }
# }

# resource "aws_elasticache_replication_group" "this" {
#   replication_group_id       = var.name
#   description                = "Redis cluster for ${var.name}"

#   engine                     = "redis"
#   engine_version            = var.engine_version
#   node_type                 = var.node_type

#   port                      = var.port

#   parameter_group_name     = var.parameter_group_name

#   num_cache_clusters       = var.num_cache_nodes

#   automatic_failover_enabled = var.automatic_failover
#   multi_az_enabled           = var.multi_az

#   subnet_group_name         = aws_elasticache_subnet_group.this.name
#   security_group_ids        = [aws_security_group.redis.id]

#   at_rest_encryption_enabled = true
#   transit_encryption_enabled  = true

#   snapshot_retention_limit   = var.snapshot_retention_limit
#   snapshot_window            = var.snapshot_window

#   auto_minor_version_upgrade = true

#   tags = {
#     Name        = var.name
#     Environment = var.environment
#   }
# }