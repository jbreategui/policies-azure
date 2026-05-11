package main

# Política NUEVA: todo recurso de compute/datos debe tener Managed Identity habilitada.
# Evita guardar credenciales en app settings o connection strings rotables a mano.

requires_identity := {
	"azurerm_linux_function_app",
}

deny[msg] {
	rc := input.resource_changes[_]
	requires_identity[rc.type]
	identities := object.get(rc.change.after, "identity", [])
	count(identities) == 0
	msg := sprintf(
		"[managed-identity] %s debe declarar un bloque identity { type = \"SystemAssigned\" }",
		[rc.address],
	)
}

deny[msg] {
	rc := input.resource_changes[_]
	requires_identity[rc.type]
	identity := rc.change.after.identity[_]
	not contains(identity.type, "SystemAssigned")
	msg := sprintf(
		"[managed-identity] %s tiene identity.type = '%s'; debe incluir 'SystemAssigned'",
		[rc.address, identity.type],
	)
}
