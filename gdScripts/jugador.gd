extends CharacterBody2D

@export var velocidad: float = 100.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Por defecto mira hacia abajo al iniciar la partida
var ultima_direccion: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var direccion := Input.get_vector("mover_izquierda", "mover_derecha", "mover_arriba", "mover_abajo")
	
	velocity = direccion * velocidad
	move_and_slide()
	
	actualizar_animacion(direccion)

func actualizar_animacion(dir: Vector2) -> void:
	if dir != Vector2.ZERO:
		ultima_direccion = dir
		
		# Animaciones de caminado
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				anim.play("caminar_derecha")
			else:
				anim.play("caminar_izquierda")
		else:
			if dir.y > 0:
				anim.play("caminar_abajo")
			else:
				anim.play("caminar_arriba")
	else:
		# Animaciones de reposo (Idle) según hacia dónde miraba por última vez
		if abs(ultima_direccion.x) > abs(ultima_direccion.y):
			if ultima_direccion.x > 0:
				anim.play("idle_derecha")
			else:
				anim.play("idle_izquierda")
		else:
			if ultima_direccion.y > 0:
				anim.play("idle_abajo")
			else:
				anim.play("idle_arriba")
