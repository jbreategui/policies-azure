resource "azurerm_storage_account" "function" {
  name                     = replace("st${var.name}fn", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true

  tags = var.tags
}

resource "azurerm_service_plan" "this" {
  name                = "asp-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.plan_sku

  tags = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = "func-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = merge(
    {
      "FUNCTIONS_WORKER_RUNTIME"     = "python"
      "ServiceBusConnection"         = var.servicebus_connection_string
      "ServiceBusQueueName"          = var.servicebus_queue_name
      "CosmosDbEndpoint"             = var.cosmos_endpoint
      "CosmosDbDatabase"             = var.cosmos_database_name
      "AzureWebJobsDisableHomepage"  = "true"
    },
    var.extra_app_settings
  )

  tags = var.tags
}
