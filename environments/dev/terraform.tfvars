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

