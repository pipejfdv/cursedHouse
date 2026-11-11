extends CharacterBody2D
@onready var area_interaccion = $AreaNPC2D
@onready var exclamacion: Sprite2D = $Exclamacion

const julian_dialogo = preload("res://dialogos/julian.dialogue")
#bandera para jugador cerca
var jugador_cerca = false
var dialogo_activo = false

func _ready():
	exclamacion.texture = preload("res://assets/disePropio/Info.png")
	exclamacion.visible = false
	
	area_interaccion.body_entered.connect(_on_body_entered)
	area_interaccion.body_exited.connect(_on_body_exited)
	
	DialogueManager.dialogue_started.connect(iniciar_dialogo)
	DialogueManager.dialogue_ended.connect(finalizar_dialogo)

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar") and not dialogo_activo:
		DialogueManager.show_dialogue_balloon(julian_dialogo, "start")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		exclamacion.visible = true
		jugador_cerca = true
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		exclamacion.visible = false
		jugador_cerca = false
func iniciar_dialogo(dialogue):
	dialogo_activo = true
func finalizar_dialogo(dialogue):
	await get_tree().create_timer(0.2).timeout
	dialogo_activo = false
	
