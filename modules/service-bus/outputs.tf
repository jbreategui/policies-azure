output "namespace_id" {
  description = "ID del Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.id
}

output "namespace_name" {
  description = "Nombre del Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.name
}

output "queue_name" {
  description = "Nombre de la cola creada."
  value       = azurerm_servicebus_queue.this.name
}

output "listener_connection_string" {
  description = "Connection string con permiso Listen para la Function App."
  value       = azurerm_servicebus_namespace_authorization_rule.function_listener.primary_connection_string
  sensitive   = true
}
