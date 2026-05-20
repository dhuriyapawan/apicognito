# ==========================================
# AUTO SCALING GROUP MODULE
# modules/asg/main.tf
# ==========================================

# ==========================================
# IAM ROLE FOR SSM
# ==========================================

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ==========================================
# ATTACH SSM POLICY
# ==========================================

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2_ssm_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ==========================================
# INSTANCE PROFILE
# ==========================================

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"

  role = aws_iam_role.ec2_ssm_role.name
}

# ==========================================
# LAUNCH TEMPLATE
# ==========================================

resource "aws_launch_template" "app_lt" {

  name_prefix = "${var.environment}-lt-"

  image_id      = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  update_default_version = true

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(
    file("${path.module}/userdata.sh")
  )

  monitoring {
    enabled = true
  }

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-app-instance"
      Environment = var.environment
    }
  }

  tags = {
    Name        = "${var.environment}-launch-template"
    Environment = var.environment
  }
}

# ==========================================
# AUTO SCALING GROUP
# ==========================================

resource "aws_autoscaling_group" "app_asg" {

  name = "${var.environment}-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = var.target_group_arns

  health_check_type         = "ELB"
  health_check_grace_period = 300

  force_delete = true

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-app-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ==========================================
# AUTO SCALING POLICY
# ==========================================

resource "aws_autoscaling_policy" "cpu_target" {

  name = "${var.environment}-cpu-scaling-policy"

  autoscaling_group_name = aws_autoscaling_group.app_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}