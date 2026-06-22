output "memos_ALB_arn" {
  value = aws_lb.memos_ALB.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs-cluster-tg.arn
}

output "alb_zone_id" {
  value = aws_lb.memos_ALB.zone_id
}

output "alb_dns_name" {
  value = aws_lb.memos_ALB.dns_name
}