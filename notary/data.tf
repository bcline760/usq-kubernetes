data "azurerm_key_vault" "usq_key_vault" {
  name                = var.usq_key_vault.name
  resource_group_name = var.usq_key_vault.resource_group_name
}

data "azurerm_key_vault_secret" "notary_tls_secret" {
  key_vault_id = data.azurerm_key_vault.usq_key_vault.id
  name         = var.usq_key_vault.secret_name
}

data "azurerm_key_vault_certificate_data" "notary_tls_certificate" {
  key_vault_id = data.azurerm_key_vault.usq_key_vault.id
  name         = var.usq_key_vault.secret_name
}
