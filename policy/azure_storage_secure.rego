package main

# Política: los Storage Accounts deben prohibir acceso público y exigir TLS 1.2.
# Base: misma del repo s03 — aplica al SA de soporte del Function App.

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_storage_account"
	rc.change.after.min_tls_version != "TLS1_2"
	msg := sprintf(
		"[storage-secure] %s debe tener min_tls_version = 'TLS1_2' (actual: %v)",
		[rc.address, rc.change.after.min_tls_version],
	)
}

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_storage_account"
	rc.change.after.allow_nested_items_to_be_public == true
	msg := sprintf(
		"[storage-secure] %s no debe permitir blobs públicos (allow_nested_items_to_be_public=false)",
		[rc.address],
	)
}

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_storage_account"
	rc.change.after.https_traffic_only_enabled == false
	msg := sprintf(
		"[storage-secure] %s debe forzar HTTPS (https_traffic_only_enabled=true)",
		[rc.address],
	)
}
