resource "aws_lb" "memos_ALB" {
  name               = "memos-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets_id
}

resource "aws_lb_target_group" "ecs-service-tg" {
  name        = "ecs-service-tg"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    port                = "8081"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.memos_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.memos_ALB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-service-tg.arn
  }
}
