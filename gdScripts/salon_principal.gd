extends Node2D

@onready var jugador = $Jugador
@onready var spawns = $Spawns

func _ready() -> void:
	if Global.punto_aparicion != "":
		if spawns.has_node(Global.punto_aparicion):
			var punto: Marker2D = spawns.get_node(Global.punto_aparicion)
			jugador.global_position = punto.global_position
			
			# Restablece la orientación original del sprite
			var sprite: AnimatedSprite2D = jugador.get_node_or_null("AnimatedSprite2D")
			if sprite:
				sprite.flip_h = false
		else:
			print("ERROR: No existe el Marker2D: ", Global.punto_aparicion)
