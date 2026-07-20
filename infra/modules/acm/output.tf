output "acm-cert-arn" {
  value       = aws_acm_certificate.memos-acm-cert.arn
  description = "ACM Cert ARN"
}
