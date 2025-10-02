# Example usage of the cert-expiry-tester module

module "cert_expiry_tester" {
  source        = "../../" # Adjust path if needed
  project       = "example-project"
  environment   = "dev"
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:example-topic"
  log_retention = 14
  domain        = "example.com"
}

