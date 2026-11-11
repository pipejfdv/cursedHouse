extends Area2D

@export_file("*.tscn") var sala_destino: String
@export var punto_destino: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("jugador") or body.name == "Jugador") and sala_destino != "":
		Global.punto_aparicion = punto_destino
		$CollisionShape2D.set_deferred("disabled", true)
		get_tree().call_deferred("change_scene_to_file", sala_destino)
