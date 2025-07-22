/*locals {
  smcd = "oldfed.abbaspour.net"
}
*/

resource "auth0_custom_domain" "my_custom_domain" {
  provider = auth0.sp
  domain = var.auth0_existing_custom_domain
  type   = "self_managed_certs"
}

resource "auth0_custom_domain_verification" "my_custom_domain_verification" {
  provider = auth0.sp
  depends_on = [cloudflare_dns_record.my_domain_name_verification_record]

  custom_domain_id = auth0_custom_domain.my_custom_domain.id

  timeouts { create = "15m" }
}

resource "cloudflare_dns_record" "my_domain_name_verification_record" {
  zone_id = var.cloudflare_zone_id
  type = upper(auth0_custom_domain.my_custom_domain.verification[0].methods[0].name)
  #name = trimsuffix(auth0_custom_domain.my_custom_domain.verification[0].methods[0].domain, ".abbaspour.net")
  name = auth0_custom_domain.my_custom_domain.verification[0].methods[0].domain
  ttl     = 300
  content = auth0_custom_domain.my_custom_domain.verification[0].methods[0].record
}

/*
output "cname-api-key" {
  value = auth0_custom_domain_verification.my_custom_domain_verification.cname_api_key
  sensitive = true
}

output "origin-domain-name" {
  value = auth0_custom_domain_verification.my_custom_domain_verification.origin_domain_name
}
*/

# Create .env file for Cloudflare Workers - run `make update-cf-secrets` to update Cloudflare
resource "local_file" "dev_vars" {
  filename = "${path.module}/../.env"
  file_permission = "600"
  content  = <<-EOT
CNAME_API_KEY=${auth0_custom_domain_verification.my_custom_domain_verification.cname_api_key}
AUTH0_EDGE_LOCATION=${auth0_custom_domain_verification.my_custom_domain_verification.origin_domain_name}
NEW_SP_DOMAIN=${var.auth0_new_custom_domain}
EOT
}
