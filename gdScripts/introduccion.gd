extends Node2D

# tomar nodos de los personajes
@onready var jugador = $Jugador
@onready var personaje1 = $Personaje1
@onready var personaje2 = $personaje2
@onready var personaje3 = $personaje3
@onready var personaje4 = $personaje4

# tomar las rutas de los personajes
@onready var ruta_jugador = $jugadorPath2D/PathFollow2D
@onready var ruta_p1 = $p1Path2D/PathFollow2D
@onready var ruta_p2 = $p2Path2D/PathFollow2D
@onready var ruta_p3 = $p3Path2D/PathFollow2D
@onready var ruta_p4 = $p4Path2D/PathFollow2D

# dialogos
const jugador_dia = preload("res://assets/dialogos/jugador.dialogue")
const personaje1_dia = preload("res://assets/dialogos/personaje1.dialogue")
const personaje2_dia = preload("res://assets/dialogos/personaje2.dialogue")
const personaje3_dia = preload("res://assets/dialogos/personaje3.dialogue")
const personaje4_dia = preload("res://assets/dialogos/personaje4.dialogue")

var velocidad := 0.3

func _ready() -> void:
	#desactivar physicas de los personajes en sus gd
	jugador.set_physics_process(false)
	personaje1.set_physics_process(false)
	personaje2.set_physics_process(false)
	personaje3.set_physics_process(false)
	personaje4.set_physics_process(false)
	
	await inicio()

func inicio():
	await mover_npc(personaje1, ruta_p1, "movFrente", "frente")
	DialogueManager.show_dialogue_balloon(personaje1_dia)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(2.2).timeout

	await mover_npc(personaje3, ruta_p3, "movAtras", "frente")
	DialogueManager.show_dialogue_balloon(personaje3_dia)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(2.2).timeout
	
	await mover_npc(personaje2, ruta_p2, "movIzquierda", "frente")
	DialogueManager.show_dialogue_balloon(personaje2_dia)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(2.2).timeout
	
	await mover_personaje(jugador, ruta_jugador)
	DialogueManager.show_dialogue_balloon(jugador_dia)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(2.2).timeout
	
	await mover_npc(personaje4, ruta_p4, "movIzquierda", "frente")
	DialogueManager.show_dialogue_balloon(personaje4_dia)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(2.2).timeout
	
	get_tree().change_scene_to_file("res://escenas/salon_principal.tscn")

func mover_personaje(personaje, ruta):
	while ruta.progress_ratio < 1.0:
		var posicion_anterior = personaje.global_position
		ruta.progress_ratio += velocidad * get_physics_process_delta_time()
		personaje.global_position = ruta.global_position
		#identificar direccion del personaje
		var direccion = (
			personaje.global_position
			- posicion_anterior
		).normalized()
		personaje.actualizar_animacion(direccion)
		await get_tree().physics_frame
	personaje.actualizar_animacion(Vector2.ZERO)

func mover_npc(
	personaje,
	ruta,
	anim_caminar,
	anim_idle
):
	var anim = personaje.get_node("AnimationPlayer")
	anim.play(anim_caminar)
	while ruta.progress_ratio < 1.0:
		ruta.progress_ratio += velocidad * get_physics_process_delta_time()
		personaje.global_position = ruta.global_position
		await get_tree().physics_frame
	anim.play(anim_idle)
