output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}

output "eks_control_plane_sg_id" {
  value = aws_security_group.eks_control_plane_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}