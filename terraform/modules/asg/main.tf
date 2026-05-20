# ==========================================
# AUTO SCALING GROUP MODULE
# modules/asg/main.tf
# ==========================================

# ==========================================
# IAM ROLE FOR SSM
# ==========================================



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





# ==========================================
# AUTO SCALING GROUP
# ==========================================


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