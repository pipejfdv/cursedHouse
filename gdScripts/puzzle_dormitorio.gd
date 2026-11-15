extends CanvasLayer

@onready var panel: Control = %PanelContainer
@onready var etiquetas_simbolos: Array[Label] = [%SimboloExt, %SimboloMed, %SimboloInt]
@onready var label_estado: Label = %LabelEstado

# 0 = Norte (▲), 1 = Este (►), 2 = Sur (▼), 3 = Oeste (◄)
const DIRECCIONES: Array[String] = ["▲", "►", "▼", "◄"]
var estado_anillos: Array[int] = [3, 2, 1]

var pista_id_actual: String = ""
var pista_titulo_actual: String = ""
var pista_texto_actual: String = ""
var pista_nodo_origen: Node = null

func _ready() -> void:
	panel.hide()
	%BtnGirarExt.pressed.connect(_rotar_anillo.bind(0))
	%BtnGirarMed.pressed.connect(_rotar_anillo.bind(1))
	%BtnGirarInt.pressed.connect(_rotar_anillo.bind(2))
	
	%BtnVerificar.pressed.connect(_comprobar_alineacion)
	%BtnCerrar.pressed.connect(cerrar_puzzle)

func abrir_puzzle(id_pista: String, titulo: String, texto: String, nodo_pista: Node) -> void:
	pista_id_actual = id_pista
	pista_titulo_actual = titulo
	pista_texto_actual = texto
	pista_nodo_origen = nodo_pista
	
	# Posición inicial desalineada (ninguno en 0 / ▲)
	estado_anillos = [3, 2, 1]
	_actualizar_visual()
	label_estado.text = ""
	
	panel.show()
	get_tree().paused = true
	%BtnGirarExt.grab_focus()

func cerrar_puzzle() -> void:
	panel.hide()
	get_tree().paused = false

func _rotar_anillo(indice: int) -> void:
	# Cada clic rota 90 grados en sentido horario (0 -> 1 -> 2 -> 3 -> 0)
	estado_anillos[indice] = (estado_anillos[indice] + 1) % 4
	
	# Mecánica vinculada: rotar el anillo exterior también mueve levemente el interior
	if indice == 0:
		estado_anillos[2] = (estado_anillos[2] + 1) % 4
		
	label_estado.text = ""
	_actualizar_visual()

func _actualizar_visual() -> void:
	for i in range(3):
		var dir_actual: int = estado_anillos[i]
		etiquetas_simbolos[i].text = DIRECCIONES[dir_actual]
		# Resalta en verde/celeste cuando el anillo apunta al Norte (0)
		if dir_actual == 0:
			etiquetas_simbolos[i].modulate = Color(0.4, 1.0, 0.6, 1.0)
		else:
			etiquetas_simbolos[i].modulate = Color(1.0, 1.0, 1.0, 1.0)

func _comprobar_alineacion() -> void:
	if estado_anillos == [0, 0, 0]:
		panel.hide()
		if Global.has_method("registrar_pista") and pista_id_actual != "":
			Global.registrar_pista(pista_id_actual)
		if is_instance_valid(pista_nodo_origen):
			pista_nodo_origen.queue_free()
			
		CuadroDialogo.mostrar_pista(pista_titulo_actual, pista_texto_actual)
	else:
		label_estado.text = "Los trazos aún no coinciden..."

func _unhandled_input(event: InputEvent) -> void:
	if panel.visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		cerrar_puzzle()
