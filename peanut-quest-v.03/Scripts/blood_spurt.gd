extends Node2D


@onready var blood_particles: CPUParticles2D = $BloodParticles




func take_damage():
	blood_particles.emitting = true
	
