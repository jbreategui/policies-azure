# policy/ — OPA / Conftest

Políticas Rego que se evalúan contra el plan de Terraform **antes** de aplicar.

## Inventario

| # | Archivo | Origen | Qué valida |
|---|---------|--------|------------|
| 1 | `azure_required_tags.rego` | Base s03 | Tags `Environment`, `ManagedBy`, `Owner`, `CostCenter` obligatorias en todos los recursos. |
| 2 | `azure_storage_secure.rego` | Base s03 | Storage Accounts: TLS 1.2, sin blobs públicos, HTTPS only. |
| 3 | `azure_function_sku.rego` | **Adaptada** (reemplaza container_resources) | Service Plan limitado a `Y1` (Consumption) o `B1`. |
| 4 | `azure_location.rego` | Base s03 | Regiones permitidas: `eastus`, `eastus2`, `westus2`. |
| 5 | `azure_compute_https_tls.rego` | **Nueva propia** | Function App: `https_only=true`, TLS 1.2, FTPS deshabilitado. |
| 6 | `azure_managed_identity.rego` | **Nueva propia** | Function App debe tener `SystemAssigned` Managed Identity. |

## Cómo correrlas

Hay **dos modos** complementarios:

### Modo 1 — Tests unitarios (rápido, no necesita Azure)

`policy/policy_test.rego` contiene 17 tests (`test_*`) que ejercen cada regla con inputs sintéticos. No requiere `terraform plan` ni autenticación.

```powershell
# Desde la raíz del repo (clase4/)
conftest verify --policy policy
```

Salida esperada:

```
17 tests, 17 passed, 0 warnings, 0 failures
```

Esto es la **evidencia formal** de que cada regla:
- pasa cuando el input cumple (`test_X_passes` → `count(deny) == 0`)
- falla cuando el input viola (`test_X_fails` → `count(deny) > 0`)

### Modo 2 — Validación contra el plan real

Una vez resueltos los tests unitarios, se valida el plan que Terraform va a aplicar:

```powershell
# Desde environments/dev/
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
conftest test --policy ../../policy tfplan.json
```

Conftest devuelve `0` si todas las reglas pasan; cualquier `deny[...]` matcheado interrumpe el flujo y bloquea el `apply`.

## Verificación negativa manual (opcional)

Para demostrar que las reglas funcionan, podés cambiar temporalmente en un módulo (ejemplos):

| Regla | Cambio que la debe disparar |
|-------|-----------------------------|
| required-tags | Borrar la tag `Owner` en `environments/dev/main.tf` (locals.tags). |
| storage-secure | Poner `min_tls_version = "TLS1_0"` en `modules/function-app/main.tf`. |
| function-sku | Cambiar `plan_sku = "P1v2"` en `environments/dev/main.tf`. |
| location | Cambiar `location = "brazilsouth"` en `terraform.tfvars`. |
| compute-https-tls | Poner `https_only = false` en el `azurerm_linux_function_app`. |
| managed-identity | Comentar el bloque `identity {}` del Function App. |

Volvé a correr `terraform plan -out=tfplan` + `conftest test` y deberías ver el `deny` correspondiente. **No hacer `apply` con esos cambios**.
