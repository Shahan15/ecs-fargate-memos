resource "aws_route53_zone" "hosted_zone" {
  name = "memos.shahankhan.co.uk"
}

resource "aws_route53_record" "route53_alias_record" {
  name            = aws_route53_zone.hosted_zone.name
  zone_id         = aws_route53_zone.hosted_zone.zone_id
  type            = "A"
  
  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}