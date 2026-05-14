extends Area2D


var in_range : bool


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		owner.in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		owner.in_range = false
		in_range = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if in_range:
			if owner.has_method("take_damage"):
				owner.take_damage(global_position)
		
