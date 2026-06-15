extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var in_range : bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false




func _input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			if not GameState.player_is_shelled:
				GameState.current_health = GameState.current_max_health
				GlobalSignalBus.emit_signal("reshell_peanut")
				
				GlobalSignalBus.emit_signal("reshell_complete")



func reshell():
	GameState.current_health = GameState.current_max_health
	GlobalSignalBus.emit_signal("reshell_peanut")
	GlobalSignalBus.emit_signal("reshell_complete")




func _on_animated_sprite_2d_animation_finished() -> void:
	if GameState.player_is_shelled:
		animated_sprite_2d.play("Idle")
	if not GameState.player_is_shelled:
		animated_sprite_2d.play("Peanut")
