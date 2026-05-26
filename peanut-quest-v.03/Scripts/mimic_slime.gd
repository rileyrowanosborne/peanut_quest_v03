extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			animated_sprite_2d.play("Attack")
			body.take_damage(global_position)


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("Idle")
