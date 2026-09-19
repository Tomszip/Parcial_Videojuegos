extends Area2D


func _on_body_entered(body: Node2D) -> void:
	# La mask de esta Area2D es solo la capa "jugador",
	# asi que body siempre es el jugador.
	body.morir()
