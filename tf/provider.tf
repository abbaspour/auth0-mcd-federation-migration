terraform {
  required_version = "~> 1.0"

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.24"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 5.7.1"
    }
  }
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_tf_client_id
  client_secret = var.auth0_tf_client_secret
  debug         = "true"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
