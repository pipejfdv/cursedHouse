extends Area2D

var jugador_cerca: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or "jugador" in body.name.to_lower():
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador") or "jugador" in body.name.to_lower():
		jugador_cerca = false

func _unhandled_input(event: InputEvent) -> void:
	if jugador_cerca and event.is_action_pressed("interactuar"):
		if Global.tiene_todas_las_pistas():
			MenuAcusacion.abrir_menu()
		else:
			CuadroDialogo.mostrar_pista("PUERTA SELLADA", "Las cadenas demoníacas rechazan cualquier intento de apertura. Necesitas reunir las 3 pruebas en la mansión antes de emitir un juicio.")
