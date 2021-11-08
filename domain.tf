#Fetch detail of Domain created using route53
data "aws_route53_zone" "opssbx_domain" {
  name = var.domain
}

resource "aws_route53_record" "opssbx_domain" {
  zone_id = data.aws_route53_zone.opssbx_domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.opssbx_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.opssbx_domain.verification_token]
}

# Add Route53 MX record
resource "aws_route53_record" "mx" {
  zone_id = data.aws_route53_zone.opssbx_domain.zone_id
  name    = aws_ses_domain_identity.opssbx_domain.id
  type    = "MX"
  ttl     = "600"
  records = ["10 inbound-smtp.${var.region}.amazonaws.com"]
  # Change to the region in which `aws_ses_domain_identity.default` is created
}

# Add Route53 TXT record for SPF
resource "aws_route53_record" "txt" {
  zone_id = data.aws_route53_zone.opssbx_domain.zone_id
  name    = aws_ses_domain_identity.opssbx_domain.id
  type    = "TXT"
  ttl     = "600"
  records = [var.spf]
}

resource "aws_ses_domain_identity" "opssbx_domain" {
  domain = var.domain
}

resource "aws_ses_domain_identity_verification" "opssbx_domain" {
  domain = aws_ses_domain_identity.opssbx_domain.id

  depends_on = [aws_route53_record.opssbx_domain]
}