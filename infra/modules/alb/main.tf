resource "aws_lb" "memos_ALB" {
  name               = "memos_ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnets_for_alb
}