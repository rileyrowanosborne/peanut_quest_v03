extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



var current_health : int = 3


func _ready() -> void:
	add_to_group("enemy")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			animated_sprite_2d.play("Attack")
			body.take_damage(global_position)


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("Idle")


func take_damage(knockback_dir : Vector2):
	
	animated_sprite_2d.play("Hurt")
	current_health -= 1
	health_check()


func health_check():
	if current_health <= 0:
		die()


func die():
	queue_free()
