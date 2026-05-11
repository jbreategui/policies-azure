#!/usr/bin/env bash
#
# Corre toda la suite de validación de políticas en un solo paso:
#   1. Tests unitarios Rego (conftest verify)
#   2. Una corrida de conftest test por cada fixture en violates-*.json
#   3. Si existe environments/dev/tfplan.json, también lo valida (happy path)
#
# Uso desde cualquier dir:
#   bash policy/run-all-tests.sh
# o desde policy/:
#   bash run-all-tests.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POLICY_DIR="$SCRIPT_DIR"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"
REAL_PLAN="$SCRIPT_DIR/../environments/dev/tfplan.json"

hr() { printf '%s\n' "============================================================"; }
section() { echo; hr; echo " $1"; hr; }

if ! command -v conftest >/dev/null 2>&1; then
  echo "ERROR: 'conftest' no está en el PATH. Instalalo desde https://www.conftest.dev/" >&2
  exit 127
fi

section "1) UNIT TESTS — conftest verify"
conftest verify --policy "$POLICY_DIR"

section "2) NEGATIVE FIXTURES — cada uno debe terminar en FAIL"

for fixture in "$FIXTURES_DIR"/violates-*.json; do
  echo
  echo "--- $(basename "$fixture") ---"
  conftest test --policy "$POLICY_DIR" "$fixture" || true
done

if [ -f "$REAL_PLAN" ]; then
  section "3) PLAN REAL — debe pasar todo (0 failures)"
  conftest test --policy "$POLICY_DIR" "$REAL_PLAN"
else
  section "3) PLAN REAL — omitido (no existe $REAL_PLAN)"
  echo "Si querés validarlo, generalo primero desde environments/dev:"
  echo "  terraform plan -out=tfplan && terraform show -json tfplan > tfplan.json"
fi

section "DONE"
