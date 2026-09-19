extends Area2D

signal jugador_llego

var abierta: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var confeti: CPUParticles2D = $Confeti


func _on_body_entered(body: Node2D) -> void:
	# La mask de esta Area2D es solo la capa "jugador", asi que body
	# siempre es el jugador. Solo chequeamos que siga vivo: si llega
	# deslizandose ya muerto (por ejemplo tras una trampa cercana),
	# no cuenta como victoria.
	if abierta or not body.vivo:
		return

	abierta = true
	sprite.play("abierta")
	confeti.emitting = true
	jugador_llego.emit()
