extends Node2D




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_on : bool = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GameState.current_brain_essence < GameState.max_brain_essence:
			if is_on:
				collect()
				if body.has_method("essence_collect"):
					body.essence_collect()




func collect():
	GameState.current_brain_essence += 1
	is_on = false
	animated_sprite_2d.play("Collected")
	GlobalSignalBus.emit_signal("essence_update")
	await get_tree().create_timer(.5).timeout
	queue_free()
	
