extends Node2D


@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var in_range : bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		cpu_particles_2d.emitting = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		cpu_particles_2d.emitting = false



func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("interact"):
			if not GameState.monk_is_active:
				GameState.current_health = 3
				GlobalSignalBus.emit_signal("monk_activate")
				GameState.monk_is_active = true
				GlobalSignalBus.emit_signal("health_check")
