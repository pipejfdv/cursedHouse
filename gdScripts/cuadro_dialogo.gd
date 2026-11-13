extends CanvasLayer

@onready var panel: Control = $PanelFondo
@onready var label_titulo: Label = $PanelFondo/MarginContainer/VBoxContainer/LabelTitulo
@onready var label_texto: Label = $PanelFondo/MarginContainer/VBoxContainer/LabelTexto
@onready var sonido_abrir: AudioStreamPlayer = $SonidoPista

var visible_activo: bool = false
var puede_cerrar: bool = false

func _ready() -> void:
	panel.hide()

func mostrar_pista(titulo: String, descripcion: String) -> void:
	# Reproduce el efecto de sonido de inspección/apertura
	if sonido_abrir and sonido_abrir.stream:
		sonido_abrir.play(0.80) # Ajusta este valor (ej. 0.2, 0.4, 0.5) según cuánto silencio tenga tu audio
	
	label_titulo.text = titulo
	label_texto.text = descripcion
	panel.show()
	visible_activo = true
	get_tree().paused = true
	
	# Evita que el mismo frame de la tecla E cierre el cuadro
	puede_cerrar = false
	await get_tree().create_timer(0.2, true, false, true).timeout
	puede_cerrar = true

func _unhandled_input(event: InputEvent) -> void:
	if visible_activo and puede_cerrar and event.is_action_pressed("interactuar"):
		get_viewport().set_input_as_handled()
		cerrar_dialogo()

func cerrar_dialogo() -> void:
	panel.hide()
	visible_activo = false
	puede_cerrar = false
	get_tree().paused = false
