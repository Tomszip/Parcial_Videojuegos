extends AnimatableBody2D

@export var distancia: Vector2 = Vector2(64, 0)
@export var duracion: float = 2.0


func _ready() -> void:
	sync_to_physics = true

	var origen := position
	var tween := create_tween().set_loops()
	tween.tween_property(self, "position", origen + distancia, duracion) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", origen, duracion) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
