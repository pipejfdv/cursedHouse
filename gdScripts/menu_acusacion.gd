extends CanvasLayer

@onready var panel: Control = $PanelContainer
@onready var btn_julian: Button = $PanelContainer/MarginContainer/VBoxContainer/BotonJulian
@onready var btn_mateo: Button = $PanelContainer/MarginContainer/VBoxContainer/BotonMateo
@onready var btn_elena: Button = $PanelContainer/MarginContainer/VBoxContainer/BotonElena
@onready var btn_cancelar: Button = $PanelContainer/MarginContainer/VBoxContainer/BotonCancelar

func _ready() -> void:
	panel.hide()
	btn_julian.pressed.connect(_on_acusar_incorrecto.bind("Julián", "El relicario de plata pura intacto prueba que no alberga al demonio."))
	btn_mateo.pressed.connect(_on_acusar_incorrecto.bind("Mateo", "El sello de agua bendita en la cocina confirma su pureza astral."))
	btn_elena.pressed.connect(_on_acusar_elena)
	btn_cancelar.pressed.connect(cerrar_menu)

func abrir_menu() -> void:
	panel.show()
	get_tree().paused = true
	# Enfocar automáticamente el primer botón para admitir mando/teclado
	btn_julian.grab_focus()

func cerrar_menu() -> void:
	panel.hide()
	get_tree().paused = false

func _on_acusar_incorrecto(sospechoso: String, razon: String) -> void:
	cerrar_menu()
	Global.victoria_alcanzada = false
	get_tree().change_scene_to_file("res://escenas/pantalla_final.tscn")

func _on_acusar_elena() -> void:
	cerrar_menu()
	Global.victoria_alcanzada = true
	get_tree().change_scene_to_file("res://escenas/pantalla_final.tscn")
