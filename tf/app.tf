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

resource "auth0_connection_clients" "saml-connection-clients" {
  provider = auth0.sp
  connection_id = auth0_connection.saml_federation_connection.id
  enabled_clients = [
    auth0_client.jwt-io.client_id
  ]
}

output "jwt-io-client_id" {
  value = auth0_client.jwt-io.client_id
}