extends Node2D

@onready var laser_pivot: Node2D = $LaserPivot
@onready var laser: RayCast2D = $LaserPivot/Laser
@onready var cpu_particles_2d: CPUParticles2D = $LaserPivot/CPUParticles2D


var is_active : bool = false


func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)


func _process(delta: float) -> void:
	if GameState.last_dir == -1:
		laser_pivot.rotation_degrees = 180
	elif GameState. last_dir == 1:
		laser_pivot.rotation_degrees = 0


func _input(event: InputEvent) -> void:
	
	if is_active:
		if event.is_action_pressed("action"):
			start_laser()
		
		if event.is_action_released("action"):
			stop_laser()


func start_laser():
	laser.set_is_casting(true)
	cpu_particles_2d.emitting = true

func stop_laser():
	laser.set_is_casting(false)
	cpu_particles_2d.emitting = false




func class_update():
	if GameState.current_class == "Test Sorceror":
		is_active = true
	else:
		is_active = false
