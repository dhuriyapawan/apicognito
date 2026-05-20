output "rds_instance_id" {
  value = aws_db_instance.main.id
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_port" {
  value = aws_db_instance.main.port
}