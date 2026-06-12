extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not GameState.mage_is_active:
			if GameState.player_is_shelled:
				collect()




func collect():
	if not GameState.mage_is_active:
		GameState.current_health = 3
		GameState.mage_is_active = true
		GlobalSignalBus.emit_signal("mage_activate")
	
	
	animated_sprite_2d.play("Destroyed")
	await animated_sprite_2d.animation_finished
	queue_free()
