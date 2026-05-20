resource "aws_launch_template" "main" {
  name_prefix = "${var.environment}-lt"
  image_id = "ami-091138d0f0d41ff90" # 
  instance_type = var.instance_type
  # key_name = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  vpc_security_group_ids = var.security_group_ids

  user_data =  base64decode(file ("${path.module}/userdata.sh"))

tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-web-instance"
      Environment = var.environment
    }
  }
  lifecycle {
    create_before_destroy = true
  } 
}


resource "aws_autoscaling_group" "main" {
  name                = "${var.environment}-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = var.target_group_arns
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-web-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}