package main

# Política: sólo regiones aprobadas para el lab.
# Base: misma del repo s03.

approved_locations := {"eastus", "eastus2", "westus2"}

tagged_types := {
	"azurerm_servicebus_namespace",
	"azurerm_storage_account",
	"azurerm_service_plan",
	"azurerm_linux_function_app",
	"azurerm_cosmosdb_account",
}

deny[msg] {
	rc := input.resource_changes[_]
	tagged_types[rc.type]
	loc := rc.change.after.location
	not approved_locations[loc]
	msg := sprintf(
		"[location] %s desplegado en '%s'; permitidos: %v",
		[rc.address, loc, approved_locations],
	)
}
