output "service_bus_namespace" {
  description = "Nombre del Service Bus namespace."
  value       = module.service_bus.namespace_name
}

output "queue_name" {
  description = "Cola que dispara la Function."
  value       = module.service_bus.queue_name
}

output "function_app_hostname" {
  description = "Hostname público (HTTPS) del Function App."
  value       = module.function_app.default_hostname
}

output "function_app_principal_id" {
  description = "Object ID de la MI de la Function (útil para grants en Cosmos)."
  value       = module.function_app.principal_id
}

output "table_endpoint" {
  description = "Endpoint HTTPS del servicio Table (sink de la Function)."
  value       = module.table_storage.primary_table_endpoint
}

output "table_name" {
  description = "Nombre de la tabla NoSQL."
  value       = module.table_storage.table_name
}
