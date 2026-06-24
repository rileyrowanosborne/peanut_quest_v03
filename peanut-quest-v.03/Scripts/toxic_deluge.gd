extends Node2D



@onready var cpu_particles_2d: CPUParticles2D = $Pivot/CPUParticles2D







var is_active : bool = false

func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)


func class_update():
	if GameState.current_class == "Toxic Deluge":
		is_active = true
		cpu_particles_2d.emitting = true
	else:
		is_active = false
		cpu_particles_2d.emitting = false
