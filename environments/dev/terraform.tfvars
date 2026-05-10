# Ajusta estos valores al RG asignado por el docente antes de `terraform apply`.
resource_group_name = "rg-brr"
location            = "eastus2"

project     = "jbreategui"
environment = "dev"
owner       = "jbreategui"
cost_center = "utec-arq-multinube"

tags = {
  Course = "M04-IaC-S03"
  Lab    = "tarea-clase4"
}

# Poner false si ya hay otra cuenta Cosmos con free tier en la suscripción.
cosmos_free_tier_enabled = true
