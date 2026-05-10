variable "name" {
  description = "Sufijo lógico para nombrar el namespace y recursos asociados (ej: jbreategui-dev)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se crean los recursos del Service Bus."
  type        = string
}

variable "location" {
  description = "Región de Azure (validada por la política azure_location.rego)."
  type        = string
}

variable "sku" {
  description = "SKU del Service Bus namespace. Basic es suficiente para colas (no soporta topics)."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "El SKU debe ser Basic o Standard (Premium queda fuera de free tier)."
  }
}

variable "queue_name" {
  description = "Nombre de la cola que dispara la Function."
  type        = string
  default     = "orders"
}

variable "queue_max_size_mb" {
  description = "Tamaño máximo de la cola en MB (1024 en Basic)."
  type        = number
  default     = 1024
}

variable "tags" {
  description = "Tags obligatorias (validadas por azure_required_tags.rego)."
  type        = map(string)
}
