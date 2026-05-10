# environments/dev

Wiring de los 3 módulos para el ambiente `dev`.

## Diagrama de integración

```
  ┌──────────────┐    listen connstr    ┌────────────────┐
  │  Service Bus │ ───────────────────► │  Function App  │
  │   (queue)    │                      │  Y1 + MI       │
  └──────────────┘                      └────────┬───────┘
                                                 │ endpoint + db
                                                 ▼
                                         ┌────────────────┐
                                         │   Cosmos DB    │
                                         │   free tier    │
                                         └────────────────┘
```

- El **Service Bus** expone una `authorization_rule` con sólo permiso `Listen` que la Function recibe vía `app_settings.ServiceBusConnection` (sensitive).
- La **Function App** se despliega en plan **Y1 (Consumption)** con `https_only = true`, TLS 1.2 y **system-assigned Managed Identity**.
- El **Cosmos DB** entrega su `endpoint` y `database_name` a la Function. La asignación de RBAC `Cosmos DB Built-in Data Contributor` al MI se puede hacer manualmente o agregar al módulo si el RG lo permite.

## Variables que debes ajustar en `terraform.tfvars`

| Variable | Por qué |
|----------|---------|
| `resource_group_name` | RG asignado por el docente (debe existir, no se crea). |
| `owner`, `cost_center` | Tags obligatorias por `azure_required_tags.rego`. |
| `cosmos_free_tier_enabled` | Sólo **una** cuenta Cosmos por suscripción puede tener free tier. Si choca, poner `false`. |

## Flujo

```powershell
# 1. Autenticación
az login
az account set --subscription "<tu-subscription-id>"

# 2. Init / Validate / Plan
terraform init
terraform validate
terraform plan -out=tfplan

# 3. Validación de políticas (desde la raíz de clase4/)
terraform show -json tfplan > tfplan.json
conftest test --policy ../../policy tfplan.json

# 4. Apply (sólo si conftest pasa)
terraform apply tfplan

# 5. Verificar
terraform output

# 6. Limpieza (al finalizar)
terraform destroy
```

> ⚠️ **No** ejecutar `terraform destroy` sobre un RG compartido con otro lab. Sólo destruye los recursos creados por este state.
