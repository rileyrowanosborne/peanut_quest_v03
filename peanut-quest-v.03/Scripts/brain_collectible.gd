extends Node2D




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collect()
		if body.has_method("collect"):
			body.collect()




func collect():
	GameState.total_brain_essence += 1
	animated_sprite_2d.play("Collected")
	await get_tree().create_timer(.5).timeout
	queue_free()
	
