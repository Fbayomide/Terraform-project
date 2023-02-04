# Host the load balancer on a custome domain via Route53

variable "domain_name" {
  default    = "fbayomide.me"
  type        = string
  description = "Domain name"
}
# get hosted zone details
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  tags = {
    Environment = "dev"
  }
}

# create a "A" record in route 53
resource "aws_route53_record" "terraform-test" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "terraform-test.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.fbayomide-lb.dns_name
    zone_id                = aws_lb.fbayomide-lb.zone_id
    evaluate_target_health = true
  }
}

# create a www "A" record in route 53
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.fbayomide-lb.dns_name
    zone_id                = aws_lb.fbayomide-lb.zone_id
    evaluate_target_health = true
  }
}