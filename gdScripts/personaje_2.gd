extends CharacterBody2D
@onready var area_interaccion = $AreaNPC2D
@onready var exclamacion: Sprite2D = $Exclamacion
# heredar ruta
@onready var seguir_ruta = get_parent()

var velocidad = 25

var direccion: Vector2
var posicio_anterior: Vector2
#dialogo
const diana_dialogo = preload("res://dialogos/diana.dialogue")
#bandera para jugador cerca
var jugador_cerca = false
#bandera para dialogo activo
var dialogo_activo = false

func _ready():
	#seguimiento de camino
	posicio_anterior = seguir_ruta.global_position
	
	exclamacion.texture = preload("res://assets/disePropio/Info.png")
	exclamacion.visible = false
	
	area_interaccion.body_entered.connect(_on_body_entered)
	area_interaccion.body_exited.connect(_on_body_exited)
	
	DialogueManager.dialogue_started.connect(iniciar_dialogo)
	DialogueManager.dialogue_ended.connect(finalizar_dialogo)

func _process(delta):
	actualizar_animacion()
	if jugador_cerca and Input.is_action_just_pressed("interactuar") and not dialogo_activo:
		DialogueManager.show_dialogue_balloon(diana_dialogo, "start")

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

func _physics_process(delta: float) -> void:
	seguir_ruta.progress += velocidad * delta
	
	var posicion = seguir_ruta.global_position
	direccion = (posicion - posicio_anterior).normalized()
	posicio_anterior = posicion

func actualizar_animacion():
	var direccion_animacion = "reposo"
	
	if direccion.x <= -0.5:
		direccion_animacion = "movIzquierda"
	elif direccion.x >= 0.5:
		direccion_animacion = "movDerecha"
	elif direccion.y >= 0.5:
		direccion_animacion = "movFrente"
	elif direccion.y <= -0.5:
		direccion_animacion = "movAtras"
		
	get_node("AnimationPlayer").play(direccion_animacion)
