variable "alb_zone_id" {
  type        = string
  description = "Zone ID - this is where the ALB is hosted"
}

variable "alb_dns_name" {
  type        = string
  description = "DNS Name of the ALB - so we can redirect traffic to that"
}
