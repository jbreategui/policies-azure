package main

# Política: todo recurso debe tener las 4 tags obligatorias.
# Base: misma del repo s03.

required_tags := {"Environment", "ManagedBy", "Owner", "CostCenter"}

# Lista de tipos que se evalúan (los demás pasan).
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
	tags := object.get(rc.change.after, "tags", {})
	missing := required_tags - {k | tags[k]}
	count(missing) > 0
	msg := sprintf(
		"[required-tags] %s '%s' no tiene las tags obligatorias: %v",
		[rc.type, rc.address, missing],
	)
}
