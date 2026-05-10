variable "name" {
  description = "Sufijo lógico para nombrar la cuenta Cosmos."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group destino."
  type        = string
}

variable "location" {
  description = "Región principal del Cosmos account."
  type        = string
}

variable "free_tier_enabled" {
  description = "Habilita el free tier (1000 RU/s + 25 GB gratis). Sólo una cuenta por suscripción puede tenerlo."
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Nombre de la base SQL."
  type        = string
  default     = "appdb"
}

variable "container_name" {
  description = "Nombre del contenedor SQL inicial."
  type        = string
  default     = "orders"
}

variable "partition_key_path" {
  description = "Path de la partition key del contenedor."
  type        = string
  default     = "/customerId"
}

variable "tags" {
  description = "Tags obligatorias."
  type        = map(string)
}
