extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GameState.player_is_shelled:
			pass
		else:
			collect()



func collect():
	GameState.current_health = GameState.current_max_health
	GlobalSignalBus.emit_signal("reshell_peanut")
	GlobalSignalBus.emit_signal("reshell_complete")
	
	
	animated_sprite_2d.play("Destroyed")
	await animated_sprite_2d.animation_finished
	queue_free()
