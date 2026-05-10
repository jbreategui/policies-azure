package main

# Política NUEVA: el Function App debe forzar HTTPS y TLS 1.2 mínimo.
# Equivale al storage_secure pero para la capa de compute.

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_linux_function_app"
	rc.change.after.https_only != true
	msg := sprintf(
		"[compute-https-tls] %s debe tener https_only = true",
		[rc.address],
	)
}

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_linux_function_app"
	site_cfg := rc.change.after.site_config[_]
	site_cfg.minimum_tls_version != "1.2"
	msg := sprintf(
		"[compute-https-tls] %s debe tener site_config.minimum_tls_version = '1.2' (actual: %v)",
		[rc.address, site_cfg.minimum_tls_version],
	)
}

deny[msg] {
	rc := input.resource_changes[_]
	rc.type == "azurerm_linux_function_app"
	site_cfg := rc.change.after.site_config[_]
	site_cfg.ftps_state != "Disabled"
	msg := sprintf(
		"[compute-https-tls] %s debe tener ftps_state = 'Disabled' (actual: %v)",
		[rc.address, site_cfg.ftps_state],
	)
}
