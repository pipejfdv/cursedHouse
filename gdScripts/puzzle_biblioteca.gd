extends CanvasLayer

@onready var panel: Control = %PanelContainer
@onready var nums: Array[Label] = [%Num1, %Num2, %Num3]
@onready var label_feedback: Label = %LabelFeedback

var digitos: Array[int] = [0, 0, 0]
const CODIGO_CORRECTO: Array[int] = [0, 2, 0]

# Datos de la pista que se revelará al resolverlo
var pista_id_actual: String = ""
var pista_titulo_actual: String = ""
var pista_texto_actual: String = ""
var pista_nodo_origen: Node = null

func _ready() -> void:
	panel.hide()
	
	# Conectar botones de subir y bajar
	%BtnSubir1.pressed.connect(_cambiar_digito.bind(0, 1))
	%BtnBajar1.pressed.connect(_cambiar_digito.bind(0, -1))
	
	%BtnSubir2.pressed.connect(_cambiar_digito.bind(1, 1))
	%BtnBajar2.pressed.connect(_cambiar_digito.bind(1, -1))
	
	%BtnSubir3.pressed.connect(_cambiar_digito.bind(2, 1))
	%BtnBajar3.pressed.connect(_cambiar_digito.bind(2, -1))
	
	%BtnAbrir.pressed.connect(_comprobar_codigo)
	%BtnCerrar.pressed.connect(cerrar_puzzle)

func abrir_puzzle(id_pista: String, titulo: String, texto: String, nodo_pista: Node) -> void:
	pista_id_actual = id_pista
	pista_titulo_actual = titulo
	pista_texto_actual = texto
	pista_nodo_origen = nodo_pista
	
	# Reiniciar diales
	digitos = [0, 0, 0]
	_actualizar_visual()
	label_feedback.text = ""
	
	panel.show()
	get_tree().paused = true
	%BtnSubir1.grab_focus()

func cerrar_puzzle() -> void:
	panel.hide()
	get_tree().paused = false

func _cambiar_digito(indice: int, delta: int) -> void:
	# Envuelve entre 0 y 9 de forma circular
	digitos[indice] = (digitos[indice] + delta + 10) % 10
	label_feedback.text = ""
	_actualizar_visual()

func _actualizar_visual() -> void:
	for i in range(3):
		nums[i].text = str(digitos[i])

func _comprobar_codigo() -> void:
	if digitos == CODIGO_CORRECTO:
		panel.hide()
		# Registrar pista y eliminar el objeto de la Biblioteca
		if Global.has_method("registrar_pista") and pista_id_actual != "":
			Global.registrar_pista(pista_id_actual)
		if is_instance_valid(pista_nodo_origen):
			pista_nodo_origen.queue_free()
			
		# Mostrar el diálogo de revelación del Relicario (mantiene la pausa hasta que cierre el diálogo)
		CuadroDialogo.mostrar_pista(pista_titulo_actual, pista_texto_actual)
	else:
		label_feedback.text = "El cerrojo no cede..."

func _unhandled_input(event: InputEvent) -> void:
	if panel.visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		cerrar_puzzle()
