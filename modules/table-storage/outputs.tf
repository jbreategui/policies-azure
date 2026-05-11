output "storage_account_id" {
  description = "ID del Storage Account de datos."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Nombre del Storage Account de datos."
  value       = azurerm_storage_account.this.name
}

output "table_name" {
  description = "Nombre de la tabla creada."
  value       = azurerm_storage_table.this.name
}

output "primary_table_endpoint" {
  description = "Endpoint HTTPS del servicio Table."
  value       = azurerm_storage_account.this.primary_table_endpoint
}

output "primary_connection_string" {
  description = "Connection string completa del SA (acceso por shared key). Sensitive."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}
