variable "resource_group_name" {
  description = "Resource Group asignado por el docente."
  type        = string
}

variable "location" {
  description = "Región de Azure (validada por azure_location.rego)."
  type        = string
  default     = "eastus2"
}

variable "project" {
  description = "Identificador corto del proyecto/estudiante (entra en los nombres de recursos)."
  type        = string
  default     = "jbreategui"
}

variable "environment" {
  description = "Etiqueta de ambiente."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner para tagging (validado por azure_required_tags.rego)."
  type        = string
}

variable "cost_center" {
  description = "Cost center para tagging."
  type        = string
}

variable "tags" {
  description = "Tags base adicionales."
  type        = map(string)
  default     = {}
}

variable "cosmos_free_tier_enabled" {
  description = "Habilitar free tier en Cosmos. Sólo una cuenta por suscripción puede tenerlo — si ya existe otra, poner false."
  type        = bool
  default     = true
}
