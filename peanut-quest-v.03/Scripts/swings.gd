extends Node2D




func _ready() -> void:
	show()


func _on_slash_area_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(owner.global_position)


func _on_slash_area_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(owner.global_position)


func _on_slash_area_air_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(owner.global_position)
