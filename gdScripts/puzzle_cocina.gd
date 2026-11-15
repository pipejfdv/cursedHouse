extends CanvasLayer

@onready var panel: Control = %PanelContainer
@onready var botones_runas: Array[Button] = [%BtnRuna0, %BtnRuna1, %BtnRuna2, %BtnRuna3]
@onready var label_estado: Label = %LabelEstado

# Secuencia fija de 5 pasos (0=Cruz, 1=Agua, 2=Fuego, 3=Luz)
const SECUENCIA_OBJETIVO: Array[int] = [1, 0, 3, 2, 1]

var indice_jugador: int = 0
var reproduciendo_secuencia: bool = false

var pista_id_actual: String = ""
var pista_titulo_actual: String = ""
var pista_texto_actual: String = ""
var pista_nodo_origen: Node = null

func _ready() -> void:
	panel.hide()
	for i in range(botones_runas.size()):
		botones_runas[i].pressed.connect(_on_runa_presionada.bind(i))
	%BtnCerrar.pressed.connect(cerrar_puzzle)

func abrir_puzzle(id_pista: String, titulo: String, texto: String, nodo_pista: Node) -> void:
	pista_id_actual = id_pista
	pista_titulo_actual = titulo
	pista_texto_actual = texto
	pista_nodo_origen = nodo_pista
	
	panel.show()
	get_tree().paused = true
	_iniciar_secuencia()

func cerrar_puzzle() -> void:
	reproduciendo_secuencia = false
	panel.hide()
	get_tree().paused = false

func _iniciar_secuencia() -> void:
	indice_jugador = 0
	reproduciendo_secuencia = true
	_bloquear_botones(true)
	label_estado.text = "Memoriza el ritual..."
	
	# Pausa inicial antes de iluminar las runas (el 2do parámetro 'true' hace que el timer funcione en pausa)
	await get_tree().create_timer(0.7, true).timeout
	if not panel.visible:
		return
		
	for paso in SECUENCIA_OBJETIVO:
		if not panel.visible:
			return
		# Iluminar botón en celeste brillante
		botones_runas[paso].modulate = Color(0.3, 1.8, 2.0, 1.0)
		await get_tree().create_timer(0.45, true).timeout
		if not panel.visible:
			return
		# Volver a color normal
		botones_runas[paso].modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.25, true).timeout
		
	reproduciendo_secuencia = false
	_bloquear_botones(false)
	label_estado.text = "Tu turno (" + str(indice_jugador) + "/" + str(SECUENCIA_OBJETIVO.size()) + ")"
	botones_runas[0].grab_focus()

func _on_runa_presionada(indice: int) -> void:
	if reproduciendo_secuencia:
		return
		
	# Destello breve al hacer clic
	botones_runas[indice].modulate = Color(0.5, 1.5, 2.0, 1.0)
	get_tree().create_timer(0.15, true).timeout.connect(
		func(): 
			if is_instance_valid(botones_runas[indice]):
				botones_runas[indice].modulate = Color(1, 1, 1, 1)
	)
	
	if indice == SECUENCIA_OBJETIVO[indice_jugador]:
		indice_jugador += 1
		label_estado.text = "Correcto (" + str(indice_jugador) + "/" + str(SECUENCIA_OBJETIVO.size()) + ")"
		
		if indice_jugador >= SECUENCIA_OBJETIVO.size():
			_completar_puzzle()
	else:
		label_estado.text = "Secuencia rota. Observa de nuevo..."
		_bloquear_botones(true)
		await get_tree().create_timer(1.0, true).timeout
		if panel.visible:
			_iniciar_secuencia()

func _completar_puzzle() -> void:
	_bloquear_botones(true)
	label_estado.text = "¡Sello estabilizado!"
	await get_tree().create_timer(0.6, true).timeout
	
	panel.hide()
	if Global.has_method("registrar_pista") and pista_id_actual != "":
		Global.registrar_pista(pista_id_actual)
	if is_instance_valid(pista_nodo_origen):
		pista_nodo_origen.queue_free()
		
	CuadroDialogo.mostrar_pista(pista_titulo_actual, pista_texto_actual)

func _bloquear_botones(bloquear: bool) -> void:
	for btn in botones_runas:
		btn.disabled = bloquear

func _unhandled_input(event: InputEvent) -> void:
	if panel.visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		cerrar_puzzle()
