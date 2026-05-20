# ==========================================
# DB SUBNET GROUP
# ==========================================

resource "aws_db_subnet_group" "main" {
  name = "${var.environment}-db-subnet-group"

  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# ==========================================
# RDS MYSQL INSTANCE
# ==========================================

resource "aws_db_instance" "main" {
  identifier = "${var.environment}-database"

  # Database Engine
  engine         = "mysql"
  engine_version = "8.0"

  # Instance
  instance_class = "db.t3.micro"

  # Storage
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # Database Config
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Networking
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids

  publicly_accessible = false
  multi_az            = false

  # Backup
  backup_retention_period = 7
  backup_window           = "03:00-04:00"

  # Maintenance
  maintenance_window = "sun:04:00-sun:05:00"

  # Monitoring
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  monitoring_interval = 60

  performance_insights_enabled = true

  # Updates
  auto_minor_version_upgrade = true

  # Deletion
  skip_final_snapshot = true

  deletion_protection = false

  # Apply Changes
  apply_immediately = true

  tags = {
    Name        = "${var.environment}-database"
    Environment = var.environment
  }
}