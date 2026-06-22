output "route53_ns_records" {
  value = aws_route53_zone.hosted_zone.name_servers
}