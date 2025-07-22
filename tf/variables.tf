## auth0 SP (Service Provider)
variable "auth0_domain" {
  type = string
  description = "Auth0 Domain for Service Provider"
}

variable "auth0_existing_custom_domain" {
  type = string
  description = "Existing Auth0 Custom Domain for Service Provider"
}

variable "auth0_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id for Service Provider"
}

variable "auth0_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret for Service Provider"
  sensitive = true
}

## auth0 IDP (Identity Provider)
variable "auth0_idp_domain" {
  type = string
  description = "Auth0 Domain for Identity Provider"
}

variable "auth0_idp_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id for Identity Provider"
}

variable "auth0_idp_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret for Identity Provider"
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
