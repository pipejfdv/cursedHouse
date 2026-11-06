extends Area2D

# Variables exportadas para personalizar cada pista desde el inspector
@export var id_sospechoso: int = 1
@export_multiline var texto_pista: String = "Descripción de la pista encontrada..."

@onready var aviso: Label = $LabelAviso
var jugador_cerca: bool = false

func _ready() -> void:
	# Conexión nativa de señales del Area2D
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		jugador_cerca = true
		aviso.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		jugador_cerca = false
		aviso.hide()

func _unhandled_input(event: InputEvent) -> void:
	if jugador_cerca and event.is_action_pressed("interactuar"):
		# Aquí se abrirá el panel de diálogo en la UI
		print("Pista recogida: ", texto_pista)
		queue_free() # La pista desaparece tras ser recolectada
