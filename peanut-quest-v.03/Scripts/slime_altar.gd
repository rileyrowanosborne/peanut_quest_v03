extends Node2D


@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var in_range : bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		cpu_particles_2d.emitting = true
		animated_sprite_2d.play("default")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		cpu_particles_2d.emitting = false
		animated_sprite_2d.play_backwards("default")


func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("interact"):
			if not GameState.slime_is_active:
				GameState.current_health = 3
				GlobalSignalBus.emit_signal("slime_activate")
				GameState.slime_is_active = true
				GlobalSignalBus.emit_signal("health_check")



func _on_animated_sprite_2d_animation_finished() -> void:
	if in_range:
		animated_sprite_2d.play("default")
