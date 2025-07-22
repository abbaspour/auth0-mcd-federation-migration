## auth0
variable "auth0_domain" {
  type = string
  description = "Auth0 Domain"
}

variable "auth0_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id"
}

variable "auth0_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret"
  sensitive = true
}

## cloudflare
variable "cloudflare_api_key" {
  description = "Cloudflare API Key"
  type = string
  sensitive = true
}

variable "cloudflare_email" {
  description = "Cloudflare Account Email"
  type = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type = string
}
