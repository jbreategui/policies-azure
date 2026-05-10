variable "name" {
  description = "Sufijo lógico para nombrar el Function App y recursos asociados (ej: jbreategui-dev)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group destino."
  type        = string
}

variable "location" {
  description = "Región de Azure."
  type        = string
}

variable "plan_sku" {
  description = "SKU del Service Plan. Y1 = Consumption (pay-per-execution, casi $0)."
  type        = string
  default     = "Y1"

  validation {
    condition     = contains(["Y1", "B1"], var.plan_sku)
    error_message = "Sólo Y1 (Consumption) o B1 (Basic) están permitidos por la política azure_function_sku.rego."
  }
}

variable "servicebus_connection_string" {
  description = "Connection string del Service Bus (output del módulo service-bus, sensitive)."
  type        = string
  sensitive   = true
}

variable "servicebus_queue_name" {
  description = "Nombre de la cola disparadora."
  type        = string
}

variable "cosmos_endpoint" {
  description = "Endpoint del Cosmos DB account (output del módulo cosmos-db)."
  type        = string
}

variable "cosmos_database_name" {
  description = "Nombre de la base SQL en Cosmos."
  type        = string
}

variable "extra_app_settings" {
  description = "App settings adicionales para extender sin tocar el módulo."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags obligatorias."
  type        = map(string)
}
