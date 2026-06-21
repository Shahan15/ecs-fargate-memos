output "memos_ALB_arn" {
  value = aws_lb.memos_ALB.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs-cluster-tg.arn
}