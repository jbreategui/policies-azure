resource "azurerm_storage_account" "this" {
  name                     = replace("st${var.name}data", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true

  tags = var.tags
}

resource "azurerm_storage_table" "this" {
  name                 = var.table_name
  storage_account_name = azurerm_storage_account.this.name
}
