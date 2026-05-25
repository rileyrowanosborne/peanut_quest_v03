extends Node2D


@onready var goop_anims: AnimatedSprite2D = $GoopAnims

@export var bounce_dir : Vector2 = Vector2(0,-1)
@export var bounce_multiplier : float = 1



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("bounce"):
			goop_anims.play("Bounce")
			body.bounce(bounce_dir, bounce_multiplier)


func _on_goop_anims_animation_finished() -> void:
	if goop_anims.animation == "Bounce":
		goop_anims.play("Idle")
