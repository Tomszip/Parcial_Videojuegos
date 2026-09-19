extends CharacterBody2D

signal murio

const VELOCIDAD := 130.0
const FUERZA_SALTO := -320.0
const VELOCIDAD_CAIDA_MAX := 400.0

const TIEMPO_COYOTE := 0.12
const TIEMPO_BUFFER_SALTO := 0.12

var tiempo_en_aire: float = 0.0
var tiempo_desde_input_salto: float = 999.0
var vivo: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonido_salto: AudioStreamPlayer = $SonidoSalto
@onready var sonido_impacto: AudioStreamPlayer = $SonidoImpacto


func _physics_process(delta: float) -> void:
	# Muerto: se le corta el control pero le sigue afectando la gravedad.
	if not vivo:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0.0, VELOCIDAD)
		move_and_slide()
		return

	# --- Gravedad ---
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, VELOCIDAD_CAIDA_MAX)
		tiempo_en_aire += delta
	else:
		tiempo_en_aire = 0.0

	# --- Memoria del input de salto (buffer) ---
	if Input.is_action_just_pressed("saltar"):
		tiempo_desde_input_salto = 0.0
	else:
		tiempo_desde_input_salto += delta

	# --- Salto ---
	var puede_saltar := tiempo_en_aire < TIEMPO_COYOTE
	var quiere_saltar := tiempo_desde_input_salto < TIEMPO_BUFFER_SALTO

	if puede_saltar and quiere_saltar:
		velocity.y = FUERZA_SALTO
		tiempo_en_aire = TIEMPO_COYOTE    # gasta el coyote time
		tiempo_desde_input_salto = 999.0  # gasta el buffer
		sonido_salto.play()

	# --- Movimiento horizontal ---
	var direccion := Input.get_axis("mover_izquierda", "mover_derecha")
	if direccion != 0.0:
		velocity.x = direccion * VELOCIDAD
		sprite.flip_h = direccion < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, VELOCIDAD)

	move_and_slide()
	actualizar_animacion(direccion)


func actualizar_animacion(direccion: float) -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	elif direccion != 0.0:
		sprite.play("run")
	else:
		sprite.play("idle")


func morir() -> void:
	if not vivo:
		return
	vivo = false
	velocity.y = -120.0   # saltito al recibir el golpe, se lee mejor
	sprite.play("hit")
	sonido_impacto.play()
	murio.emit()


func ganar() -> void:
	if not vivo:
		return
	vivo = false
	sprite.play("idle")
