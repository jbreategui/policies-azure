output "account_id" {
  description = "ID de la cuenta Cosmos."
  value       = azurerm_cosmosdb_account.this.id
}

output "account_name" {
  description = "Nombre de la cuenta Cosmos."
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "Endpoint HTTPS del Cosmos account (consumido por la Function)."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "database_name" {
  description = "Nombre de la base SQL creada."
  value       = azurerm_cosmosdb_sql_database.this.name
}

output "container_name" {
  description = "Nombre del contenedor SQL creado."
  value       = azurerm_cosmosdb_sql_container.this.name
}
