extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var bounce_dir : Vector2 = Vector2(0,-1)
@export var bounce_multiplier : float = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("bounce"):
			animated_sprite_2d.play("Bounce")
			body.bounce(bounce_dir, bounce_multiplier)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Bounce":
		animated_sprite_2d.play("Idle")
