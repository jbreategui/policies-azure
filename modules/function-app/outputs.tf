output "function_app_id" {
  description = "ID del Linux Function App."
  value       = azurerm_linux_function_app.this.id
}

output "function_app_name" {
  description = "Nombre del Function App."
  value       = azurerm_linux_function_app.this.name
}

output "default_hostname" {
  description = "Hostname público del Function App (https only)."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "principal_id" {
  description = "Object ID de la Managed Identity system-assigned (para grants de RBAC)."
  value       = azurerm_linux_function_app.this.identity[0].principal_id
}

output "storage_account_id" {
  description = "ID del Storage Account de soporte de la Function."
  value       = azurerm_storage_account.function.id
}
