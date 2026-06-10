extends Node2D


var rotation_speed : float = 240.0


func _process(delta: float) -> void:
	
	rotation_degrees += rotation_speed * delta





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)
