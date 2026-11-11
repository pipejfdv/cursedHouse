extends Area2D

@export var id_pista: String = ""
@export var titulo_pista: String = "Pista Encontrada"
@export_multiline var texto_pista: String = "Descripción de la pista."

var jugador_cerca: bool = false
var prompt_label: Label = null

func _ready() -> void:
	# Busca automáticamente el Label hijo dentro de la pista
	for hijo in get_children():
		if hijo is Label:
			prompt_label = hijo
			break
	
	if prompt_label:
		prompt_label.visible = false

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	# Acepta si está en el grupo "jugador" o si el nombre contiene "jugador"
	if body.is_in_group("jugador") or "jugador" in body.name.to_lower():
		jugador_cerca = true
		if prompt_label:
			prompt_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador") or "jugador" in body.name.to_lower():
		jugador_cerca = false
		if prompt_label:
			prompt_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if jugador_cerca and event.is_action_pressed("interactuar"):
		CuadroDialogo.mostrar_pista(titulo_pista, texto_pista)
		if Global.has_method("registrar_pista") and id_pista != "":
			Global.registrar_pista(id_pista)
		queue_free()
