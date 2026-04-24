extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var slash_area: Area2D = $SlashArea


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing"):
		animated_sprite_2d.play("default")
		


func _process(delta: float) -> void:
	if animated_sprite_2d.is_playing():
		slash_area.monitoring = true
	else:
		slash_area.monitoring = false
