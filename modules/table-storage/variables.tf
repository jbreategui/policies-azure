variable "name" {
  description = "Sufijo lógico para nombrar la cuenta de Storage de datos."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group destino."
  type        = string
}

variable "location" {
  description = "Región de Azure (validada por azure_location.rego)."
  type        = string
}

variable "table_name" {
  description = "Nombre de la tabla NoSQL (sink de la Function)."
  type        = string
  default     = "orders"
}

variable "tags" {
  description = "Tags obligatorias (validadas por azure_required_tags.rego)."
  type        = map(string)
}
