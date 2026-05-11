data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}

locals {
  # Sufijo único corto, garantiza unicidad global donde Azure lo requiere.
  name = "${var.project}-${var.environment}-${random_string.suffix.result}"

  tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    CostCenter  = var.cost_center
  })
}

module "service_bus" {
  source = "../../modules/service-bus"

  name                = local.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  sku                 = "Basic"
  queue_name          = "orders"
  tags                = local.tags
}

module "table_storage" {
  source = "../../modules/table-storage"

  name                = local.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  table_name          = "orders"
  tags                = local.tags
}

module "function_app" {
  source = "../../modules/function-app"

  name                = local.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  plan_sku            = "Y1"

  servicebus_connection_string = module.service_bus.listener_connection_string
  servicebus_queue_name        = module.service_bus.queue_name

  table_connection_string = module.table_storage.primary_connection_string
  table_name              = module.table_storage.table_name

  tags = local.tags
}
