extends AnimatableBody2D

@export var demora: float = 0.4
@export var reaparece_en: float = 3.0

var cayendo: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var forma: CollisionShape2D = $CollisionShape2D


func _on_detector_body_entered(_body: Node2D) -> void:
	if cayendo:
		return
	cayendo = true

	sprite.play("temblar")
	await get_tree().create_timer(demora).timeout

	forma.set_deferred("disabled", true)
	sprite.hide()
	await get_tree().create_timer(reaparece_en).timeout

	forma.set_deferred("disabled", false)
	sprite.show()
	sprite.play("idle")
	cayendo = false
