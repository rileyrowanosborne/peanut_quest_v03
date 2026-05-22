extends Node2D


#nodes
@onready var duration_timer: Timer = $DurationTimer
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@onready var cpu_particles_2d: CPUParticles2D = $LeftLaserLauncher/CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $RightLaserLauncher/CPUParticles2D2


@onready var left_laser_launcher: AnimatedSprite2D = $LeftLaserLauncher
@onready var right_laser_launcher: AnimatedSprite2D = $RightLaserLauncher


#variables
@export var is_constant : bool = false

@export var beam_duration : float = 1.0


var currently_active : bool = true





#if is_constant = true, the beam does not switch on and off. If not the beam will flicker at the set duration.

func _ready() -> void:
	add_to_group("laser")
	
	
	if not is_constant:
		duration_timer.start(beam_duration)
	


func _on_duration_timer_timeout() -> void:
	
	
	if currently_active:
		left_laser_launcher.play("Idle")
		right_laser_launcher.play("Idle")
		currently_active = false
		collision_shape_2d.disabled = true
		animated_sprite_2d.hide()
	elif not currently_active:
		left_laser_launcher.play("FireUp")
		right_laser_launcher.play("FireUp")
		cpu_particles_2d.emitting = true
		cpu_particles_2d_2.emitting = true
		await get_tree().create_timer(1).timeout
		left_laser_launcher.play("Firing")
		right_laser_launcher.play("Firing")
		currently_active = true
		collision_shape_2d.disabled = false
		animated_sprite_2d.show()
	
	duration_timer.start(1)
