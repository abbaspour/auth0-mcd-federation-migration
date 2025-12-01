resource "auth0_client" "jwt-io" {
  provider = auth0.sp
  name                       = "JWT.io for Federation Migration Demo"
  description                = "SPA application for Federation Migration Demo"
  app_type                   = "spa"
  is_first_party             = true
  oidc_conformant            = true

  callbacks = [
    "https://jwt.io"
  ]

  allowed_logout_urls = []
  web_origins = []

  grant_types = [
    "implicit",
  ]
}

output "jwt-io-client_id" {
  value = auth0_client.jwt-io.client_id
}