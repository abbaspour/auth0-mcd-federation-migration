# SAML Federation Configuration
locals {
  connection-name = "saml-federation-connection"
}
# Create a new application in the IDP Auth0 tenant with SAML enabled
resource "auth0_client" "saml_idp_app" {
  provider = auth0.idp
  name = "SAML Federation IDP"
  app_type = "regular_web"
  callbacks = ["https://${var.auth0_existing_custom_domain}/login/callback"]
  
  # Enable SAML for this application
  addons {
    samlp {
      audience = "urn:auth0:${trimsuffix(var.auth0_domain, ".auth0.com")}:${local.connection-name}"
      recipient = "https://${var.auth0_existing_custom_domain}/login/callback"
      destination = "https://${var.auth0_existing_custom_domain}/login/callback"
      mappings = {}
      create_upn_claim = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is = false
      map_identities = false
      name_identifier_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
      name_identifier_probes = ["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"]
      signing_cert = ""
      lifetime_in_seconds = 3600
      sign_response = true
      typed_attributes = false
      include_attribute_name_format = true
      signature_algorithm = "rsa-sha256"
      digest_algorithm = "sha256"
    }
  }
}

output "idp-metadata-url" {
  value = "https://${var.auth0_idp_domain}/samlp/metadata/${auth0_client.saml_idp_app.client_id}"
}

data "auth0_connection" "UPA" {
  provider = auth0.idp
  name = "Username-Password-Authentication"
}

resource "auth0_connection_clients" "UPA-for-IdP" {
  provider = auth0.idp
  connection_id = data.auth0_connection.UPA.id
  enabled_clients = [
    auth0_client.saml_idp_app.client_id
  ]
}


# Create a SAML connection in the SP Auth0 tenant pointing to the upstream SAML IDP
resource "auth0_connection" "saml_federation_connection" {
  provider = auth0.sp
  name = local.connection-name
  strategy = "samlp"
  options {
    idp_initiated {
      enabled = false
    }
    allowed_audiences = []
    signing_cert = auth0_client.saml_idp_app.addons.0.samlp.0.signing_cert
    sign_in_endpoint = "https://${var.auth0_idp_domain}/samlp/${auth0_client.saml_idp_app.client_id}"
    sign_out_endpoint = "https://${var.auth0_idp_domain}/samlp/metadata/${auth0_client.saml_idp_app.client_id}"
    disable_sign_out = false
    tenant_domain = var.auth0_domain
    domain_aliases = []
    protocol_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    request_template = ""
    user_id_attribute = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    signature_algorithm = "rsa-sha256"
    digest_algorithm = "sha256"
    #field_mapping = {}
    metadata_url = "https://${var.auth0_idp_domain}/samlp/metadata/${auth0_client.saml_idp_app.client_id}"
    #metadata_xml = ""
  }
}

output "saml-connection-id" {
  value = auth0_connection.saml_federation_connection.id
}

resource "auth0_connection_clients" "saml-connection-clients" {
  provider = auth0.sp
  connection_id = auth0_connection.saml_federation_connection.id
  enabled_clients = [
    auth0_client.jwt-io.client_id
  ]
}