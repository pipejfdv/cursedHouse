extends Control

@onready var fondo: TextureRect = %FondoResultado
@onready var btn_reiniciar: Button = %BtnReiniciar
@onready var btn_salir: Button = %BtnSalir

# Carga tus dos imágenes (ajusta las rutas si las guardaste en otra subcarpeta)
const TEX_VICTORIA: Texture2D = preload("res://assets/escenas/pantalla_victoria.png")
const TEX_DERROTA: Texture2D = preload("res://assets/escenas/pantalla_derrota.png")

func _ready() -> void:
	# Asegurarnos de que el juego no esté pausado al llegar aquí
	get_tree().paused = false
	
	if Global.get("victoria_alcanzada") == true:
		fondo.texture = TEX_VICTORIA
	else:
		fondo.texture = TEX_DERROTA
		
	btn_reiniciar.pressed.connect(_on_reiniciar_pressed)
	btn_salir.pressed.connect(_on_salir_pressed)
	btn_reiniciar.grab_focus()

func _on_reiniciar_pressed() -> void:
	Global.reiniciar_partida()
	# Cambia esta ruta por la escena inicial de tu juego (ej. entrada.tscn o salon_principal.tscn)
	get_tree().change_scene_to_file("res://escenas/salon_principal.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
