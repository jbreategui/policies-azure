resource "azurerm_servicebus_namespace" "this" {
  name                = "sb-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  minimum_tls_version = "1.2"

  local_auth_enabled            = true
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_servicebus_queue" "this" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.this.id

  max_size_in_megabytes                = var.queue_max_size_mb
  default_message_ttl                  = "P14D"
  dead_lettering_on_message_expiration = true
  max_delivery_count                   = 10
}

resource "azurerm_servicebus_namespace_authorization_rule" "function_listener" {
  name         = "function-listener"
  namespace_id = azurerm_servicebus_namespace.this.id

  listen = true
  send   = false
  manage = false
}
