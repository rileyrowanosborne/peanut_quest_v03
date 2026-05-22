extends Area2D






func _on_body_entered(body: Node2D) -> void:
	
	if owner.is_in_group("laser"):
		if body.is_in_group("player"):
			if body.has_method("take_laser_damage"):
				body.take_laser_damage()
	
	elif body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(owner.global_position)



	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(owner.global_position)
