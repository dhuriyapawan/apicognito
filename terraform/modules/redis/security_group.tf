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

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis-sg"
  description = "Redis security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-redis-sg"
  }
}
resource "aws_security_group_rule" "redis_ingress" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis.id
  source_security_group_id = var.allowed_security_group_ids[0]
}
resource "aws_security_group_rule" "redis_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redis.id
}