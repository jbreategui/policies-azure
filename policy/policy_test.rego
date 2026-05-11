package main

# Tests unitarios para las 6 políticas Rego.
#
# Convención: por cada política hay al menos un test "passes" (input
# correcto, count(deny) == 0) y un test "fails" (input violatorio,
# count filtrado por prefijo del mensaje > 0).
#
# Correr:  conftest verify --policy policy

# ---------------------------------------------------------------
# Helper: filtra mensajes de deny que empiezan con un prefijo.
# ---------------------------------------------------------------
denies_with_prefix(denies, prefix) := count([m | m := denies[_]; startswith(m, prefix)])

# ===============================================================
# 1) azure_required_tags.rego
# ===============================================================

test_required_tags_all_present_passes {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_storage_account",
		"address": "test_sa",
		"change": {"after": {
			"location":                       "eastus",
			"min_tls_version":                "TLS1_2",
			"https_traffic_only_enabled":     true,
			"allow_nested_items_to_be_public": false,
			"tags": {
				"Environment": "dev",
				"ManagedBy":   "Terraform",
				"Owner":       "jbreategui",
				"CostCenter":  "utec",
			},
		}},
	}]}
	denies_with_prefix(result, "[required-tags]") == 0
}

test_required_tags_missing_owner_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_storage_account",
		"address": "test_sa",
		"change": {"after": {
			"location":                       "eastus",
			"min_tls_version":                "TLS1_2",
			"https_traffic_only_enabled":     true,
			"allow_nested_items_to_be_public": false,
			"tags": {
				"Environment": "dev",
				"ManagedBy":   "Terraform",
				"CostCenter":  "utec",
			},
		}},
	}]}
	denies_with_prefix(result, "[required-tags]") > 0
}

test_required_tags_no_tags_block_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_servicebus_namespace",
		"address": "test_sb",
		"change": {"after": {"location": "eastus"}},
	}]}
	denies_with_prefix(result, "[required-tags]") > 0
}

# ===============================================================
# 2) azure_storage_secure.rego
# ===============================================================

test_storage_secure_compliant_passes {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_storage_account",
		"address": "test_sa",
		"change": {"after": {
			"location":                       "eastus",
			"min_tls_version":                "TLS1_2",
			"https_traffic_only_enabled":     true,
			"allow_nested_items_to_be_public": false,
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[storage-secure]") == 0
}

test_storage_secure_tls10_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_storage_account",
		"address": "test_sa",
		"change": {"after": {
			"location":                       "eastus",
			"min_tls_version":                "TLS1_0",
			"https_traffic_only_enabled":     true,
			"allow_nested_items_to_be_public": false,
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[storage-secure]") > 0
}

test_storage_secure_public_blobs_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_storage_account",
		"address": "test_sa",
		"change": {"after": {
			"location":                       "eastus",
			"min_tls_version":                "TLS1_2",
			"https_traffic_only_enabled":     true,
			"allow_nested_items_to_be_public": true,
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[storage-secure]") > 0
}

# ===============================================================
# 3) azure_function_sku.rego
# ===============================================================

test_function_sku_y1_passes {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_service_plan",
		"address": "test_plan",
		"change": {"after": {
			"location": "eastus",
			"sku_name": "Y1",
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[function-sku]") == 0
}

test_function_sku_premium_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_service_plan",
		"address": "test_plan",
		"change": {"after": {
			"location": "eastus",
			"sku_name": "P1v2",
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[function-sku]") > 0
}

# ===============================================================
# 4) azure_location.rego
# ===============================================================

test_location_eastus_passes {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_cosmosdb_account",
		"address": "test_cos",
		"change": {"after": {
			"location": "eastus",
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[location]") == 0
}

test_location_brazil_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_servicebus_namespace",
		"address": "test_sb",
		"change": {"after": {
			"location": "brazilsouth",
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[location]") > 0
}

# ===============================================================
# 5) azure_compute_https_tls.rego (NUEVA)
# ===============================================================

test_compute_https_tls_compliant_passes {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_linux_function_app",
		"address": "test_fn",
		"change": {"after": {
			"location":   "eastus",
			"https_only": true,
			"identity":   [{"type": "SystemAssigned"}],
			"site_config": [{
				"minimum_tls_version": "1.2",
				"ftps_state":          "Disabled",
			}],
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[compute-https-tls]") == 0
}

test_compute_https_tls_http_allowed_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_linux_function_app",
		"address": "test_fn",
		"change": {"after": {
			"location":   "eastus",
			"https_only": false,
			"identity":   [{"type": "SystemAssigned"}],
			"site_config": [{
				"minimum_tls_version": "1.2",
				"ftps_state":          "Disabled",
			}],
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[compute-https-tls]") > 0
}

test_compute_https_tls_old_tls_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_linux_function_app",
		"address": "test_fn",
		"change": {"after": {
			"location":   "eastus",
			"https_only": true,
			"identity":   [{"type": "SystemAssigned"}],
			"site_config": [{
				"minimum_tls_version": "1.0",
				"ftps_state":          "Disabled",
			}],
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[compute-https-tls]") > 0
}

# ===============================================================
# 6) azure_managed_identity.rego (NUEVA)
# ===============================================================

test_managed_identity_present_passes {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_linux_function_app",
		"address": "test_fn",
		"change": {"after": {
			"location":   "eastus",
			"https_only": true,
			"identity":   [{"type": "SystemAssigned"}],
			"site_config": [{
				"minimum_tls_version": "1.2",
				"ftps_state":          "Disabled",
			}],
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[managed-identity]") == 0
}

test_managed_identity_missing_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_linux_function_app",
		"address": "test_fn",
		"change": {"after": {
			"location":   "eastus",
			"https_only": true,
			"site_config": [{
				"minimum_tls_version": "1.2",
				"ftps_state":          "Disabled",
			}],
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[managed-identity]") > 0
}

test_managed_identity_userassigned_only_fails {
	result := deny with input as {"resource_changes": [{
		"type": "azurerm_linux_function_app",
		"address": "test_fn",
		"change": {"after": {
			"location":   "eastus",
			"https_only": true,
			"identity":   [{"type": "UserAssigned"}],
			"site_config": [{
				"minimum_tls_version": "1.2",
				"ftps_state":          "Disabled",
			}],
			"tags": {"Environment": "dev", "ManagedBy": "tf", "Owner": "jb", "CostCenter": "x"},
		}},
	}]}
	denies_with_prefix(result, "[managed-identity]") > 0
}
