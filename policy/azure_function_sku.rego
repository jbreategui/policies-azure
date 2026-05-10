package main

# Política: el Service Plan del Function App sólo puede ser Y1 (Consumption) o B1 (Basic).
# Reemplaza azure_container_resources.rego del s03, manteniendo el espíritu:
# acotar el SKU para controlar costo del lab.

allowed_skus := {"Y1", "B1"}

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_service_plan"
	sku := rc.change.after.sku_name
	not allowed_skus[sku]
	msg := sprintf(
		"[function-sku] %s usa SKU '%s'; permitidos: %v",
		[rc.address, sku, allowed_skus],
	)
}
