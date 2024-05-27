resource "aws_wafv2_web_acl" "grafana_waf" {
  name        = "grafana-waf"
  scope       = "REGIONAL"
  description = "WAF for Grafana ALB"

  default_action {
    allow {}
  }

  rule {
    name     = "IPBlock"
    priority = 1

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.grafana_ip_set.arn
      }
    }

    action {
      block {}
    }

    visibility_config {
      sampled_requests_enabled    = true
      cloudwatch_metrics_enabled  = true
      metric_name                 = "IPBlock"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled  = true
    metric_name                 = "grafanaWAF"
    sampled_requests_enabled    = true
  }
}

resource "aws_wafv2_ip_set" "grafana_ip_set" {
  name        = "grafana-ip-set"
  scope       = "REGIONAL"
  description = "IP set for Grafana WAF"

  ip_address_version = "IPV4"

  addresses = ["203.0.113.0/24"]  # Replace with the IP range you want to block
}

resource "aws_wafv2_web_acl_association" "grafana_waf_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.grafana_waf.arn
}
