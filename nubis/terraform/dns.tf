
resource "aws_route53_zone" "hosted_zone" {
  name = "${lookup(var.dns_name, var.environment)}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    ServiceName     = "${var.service_name}"
    Environment     = "${var.environment}"
    TechnicalOwner  = "${var.technical_owner}"
  }
}

resource "aws_route53_zone" "apex" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"

  name    = "${lookup(var.dns_name, var.environment)}"

  type    = "CNAME"
  ttl     = "600"
  records = [
    "${module.dns_web.fqdn}"
  ]
}

resource "aws_route53_record" "blog" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"
  name    = "blog"

  type    = "A"
  ttl     = "3600"
  records = [
    "103.3.61.182"
  ]
}

resource "aws_route53_record" "free-fox" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"
  name    = "free-fox"

  type    = "A"
  ttl     = "3600"
  records = [
    "52.187..23.157"
  ]
}

resource "aws_route53_record" "pto" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"

  name    = "pto"
  type    = "A"
  ttl     = "3600"
  records = [
    "118.163.10.187"
  ]
}

resource "aws_route53_record" "tech" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"

  name    = "tech"
  type    = "A"
  ttl     = "3600"
  records = [
    "103.3.61.182"
  ]
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"

  name  = "www"
  type  = "CNAME"
  ttl   = "600"
}

resource "aws_route53_record" "_domainconnect" {
  zone_id = "${aws_route53_zone.hosted_zone.id}"

  name    = "_domainconnect"
  type    = "CNAME"
  ttl     = "600"
  records = [
    "_domainconnect.gd.domaincontrol.com"
  ]
}
