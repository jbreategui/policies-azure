# policy/fixtures/

Fixtures sintéticas (mini `tfplan.json`) que **violan intencionalmente** cada política.
Sirven para capturar evidencia de que las reglas funcionan (screenshots).

## Cómo correr cada una

Desde `clase4/`:

```powershell
# 1) Falta tag obligatoria → debería disparar [required-tags]
conftest test --policy policy policy\fixtures\violates-required-tags.json

# 2) Storage inseguro (TLS 1.0, blobs públicos, sin HTTPS) → [storage-secure]
conftest test --policy policy policy\fixtures\violates-storage-secure.json

# 3) Service Plan Premium → [function-sku]
conftest test --policy policy policy\fixtures\violates-function-sku.json

# 4) Región brazilsouth → [location]
conftest test --policy policy policy\fixtures\violates-location.json

# 5) Function App http + TLS 1.0 + FTPS abierto → [compute-https-tls]
conftest test --policy policy policy\fixtures\violates-compute-https-tls.json

# 6) Function App sin Managed Identity → [managed-identity]
conftest test --policy policy policy\fixtures\violates-managed-identity.json

# 7) BONUS: combina varias violaciones en un solo plan → 8+ FAIL
conftest test --policy policy policy\fixtures\violates-all.json
```

## Qué esperar

Cada comando termina con código de salida ≠ 0 y un bloque `FAIL` similar a:

```
FAIL - policy\fixtures\violates-required-tags.json - main - [required-tags] azurerm_storage_account 'module.bad.azurerm_storage_account.no_owner_tag' no tiene las tags obligatorias: {"Owner"}

1 test, 0 passed, 0 warnings, 1 failure, 0 exceptions
```

El mensaje entre `[...]` te dice **qué política** disparó. Si el comando termina con `0 failures`, algo está mal: la política no se está matcheando.

## Para entrega / evidencia

1. Tomá screenshot de cada uno de los 7 comandos mostrando el `FAIL` correspondiente.
2. Adicionalmente, tomá un screenshot del **happy path** (todas pasan) con:
   ```powershell
   conftest verify --policy policy   # 17 tests, 17 passed
   ```

## Atajo: correr toda la suite de una

Hay scripts en `policy/run-all-tests.sh` (bash) y `policy/run-all-tests.ps1` (PowerShell) que ejecutan en orden:

1. `conftest verify` — 17 tests unitarios.
2. Una corrida de `conftest test` por cada `violates-*.json` (cada una termina en FAIL).
3. Si existe `environments/dev/tfplan.json`, también lo valida (happy path).

```bash
# Linux / Git Bash:
bash policy/run-all-tests.sh

# Windows PowerShell:
.\policy\run-all-tests.ps1
```

Una sola corrida, una sola captura.
