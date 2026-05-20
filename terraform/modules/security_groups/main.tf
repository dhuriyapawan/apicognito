############################
# ALB Security Group
############################
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

############################
# EKS Node Security Group
############################
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.environment}-eks-node-sg"
  description = "EKS Node Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ALB to NodePort"
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "Node internal communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-eks-node-sg"
    Environment = var.environment
  }
}

############################
# EKS Control Plane SG (optional reference)
############################
resource "aws_security_group" "eks_control_plane_sg" {
  name        = "${var.environment}-eks-control-plane-sg"
  description = "EKS Control Plane Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow nodes to API server"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_node_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-eks-control-plane-sg"
    Environment = var.environment
  }
}

############################
# Bastion / SSM EC2 SG
############################
resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}-bastion-sg"
  description = "Bastion or SSM EC2 SG"
  vpc_id      = var.vpc_id

#   ingress {
#     description = "SSH (optional - avoid in prod if using SSM only)"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = var.ssh_allowed_cidrs
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-bastion-sg"
    Environment = var.environment
  }
}