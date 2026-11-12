extends Control

const intro = preload("res://dialogos/intro.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(finalizarIntro)
	DialogueManager.show_dialogue_balloon(intro)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func finalizarIntro(resource):
	get_tree().change_scene_to_file("res://escenas/salon_principal.tscn")
