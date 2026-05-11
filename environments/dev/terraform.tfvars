# Ajusta estos valores al RG asignado por el docente antes de `terraform apply`.
resource_group_name = "rg-brr"
location            = "eastus"

project     = "jbreategui"
environment = "dev"
owner       = "jbreategui"
cost_center = "utec-arq-multinube"

tags = {
  Course = "M04-IaC-S03"
  Lab    = "tarea-clase4"
}

# La suscripción del lab ya tiene otra cuenta Cosmos con free tier
# (sólo se permite una por sub). false ⇒ el módulo activa serverless,
# que es ~$0 idle y suficiente para esta tarea.
cosmos_free_tier_enabled = false
