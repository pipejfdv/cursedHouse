extends Area2D

@export_file("*.tscn") var sala_destino: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") and sala_destino != "":
		# Desactiva la colisión de inmediato para evitar disparos dobles
		$CollisionShape2D.set_deferred("disabled", true)
		# Ejecuta el cambio de escena fuera del ciclo de físicas
		get_tree().call_deferred("change_scene_to_file", sala_destino)
