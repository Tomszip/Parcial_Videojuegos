extends Node2D

@export var demora_reinicio: float = 1.2
@export var demora_victoria: float = 0.6

var reiniciando: bool = false
var ui_victoria: CanvasLayer

@onready var jugador: CharacterBody2D = $Jugador
@onready var puerta: Area2D = $Puerta
@onready var musica: AudioStreamPlayer = $Musica


func _ready() -> void:
	jugador.murio.connect(_on_jugador_murio)
	puerta.jugador_llego.connect(_on_jugador_gano)
	_crear_ui_victoria()
	_iniciar_musica()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reiniciar"):
		reiniciar()


func _on_jugador_murio() -> void:
	await get_tree().create_timer(demora_reinicio).timeout
	reiniciar()


func _on_jugador_gano() -> void:
	jugador.ganar()
	# deja ver un instante el confeti antes de tapar la pantalla con el cartel
	await get_tree().create_timer(demora_victoria).timeout
	ui_victoria.show()


func reiniciar() -> void:
	if reiniciando:
		return
	reiniciando = true
	get_tree().reload_current_scene()


func _crear_ui_victoria() -> void:
	ui_victoria = CanvasLayer.new()
	ui_victoria.layer = 100
	add_child(ui_victoria)

	var fondo := ColorRect.new()
	fondo.color = Color(0, 0, 0, 0.55)
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_victoria.add_child(fondo)

	var centro := CenterContainer.new()
	centro.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_victoria.add_child(centro)

	var caja := VBoxContainer.new()
	caja.add_theme_constant_override("separation", 8)
	centro.add_child(caja)

	var titulo := Label.new()
	titulo.text = "¡GANASTE!"
	titulo.add_theme_font_size_override("font_size", 28)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caja.add_child(titulo)

	var sub := Label.new()
	sub.text = "Presiona R para jugar de nuevo"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caja.add_child(sub)

	ui_victoria.hide()


func _iniciar_musica() -> void:
	# El loop se activa por codigo (no queda guardado en el .import),
	# asi el archivo de audio suena en bucle mientras dure el nivel.
	if musica.stream is AudioStreamWAV:
		musica.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	musica.play()
