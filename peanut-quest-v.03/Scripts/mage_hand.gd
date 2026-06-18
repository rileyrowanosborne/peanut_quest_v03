extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var fire_ball_cooldown_timer: Timer = $FireBallCooldownTimer
@onready var laser: RayCast2D = $Pivot/Laser
@onready var pivot: Node2D = $Pivot
@onready var cpu_particles_2d: CPUParticles2D = $Pivot/CPUParticles2D


@export var fireball_scene : PackedScene


var can_attack : bool = true


var enemy_in_range : bool = false
var enemy_location : Vector2

func _ready() -> void:
	GlobalSignalBus.connect("mage_deactivate", despawn_hand)
	
func _process(delta: float) -> void:
	
	if GameState.last_dir == -1:
		pivot.rotation_degrees = 180
	elif GameState.last_dir == 1:
		pivot.rotation_degrees = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if GameState.current_mage_level == GameState.max_ability_level:
			if can_attack:
				fire_laser()
		else:
			if can_attack:
				can_attack = false
				spawn_fireball(marker_2d.global_position)
				fire_ball_cooldown_timer.start(GameState.current_fireball_delay)
				
	
	if event.is_action_released("action"):
		if GameState.current_mage_level == GameState.max_ability_level:
			stop_laser()


func despawn_hand():
	queue_free()


func fire_laser():
	laser.set_is_casting(true)
	cpu_particles_2d.emitting = true

func stop_laser():
	laser.set_is_casting(false)
	cpu_particles_2d.emitting = false

func spawn_fireball(world_location : Vector2):
	if fireball_scene:
			var fireball_instance = fireball_scene.instantiate()
			get_tree().current_scene.call_deferred("add_child", fireball_instance)
			fireball_instance.global_position = world_location
			if enemy_in_range:
				if fireball_instance.has_method("target_update"):
					fireball_instance.target_update(enemy_location)
			else:
				if fireball_instance.has_method("default_target"):
					fireball_instance.default_target()
				if fireball_instance.has_method("direction_update"):
					fireball_instance.direction_update(GameState.last_dir)


func _on_fire_ball_cooldown_timer_timeout() -> void:
	can_attack = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_range = true
		enemy_location = body.global_position


func _on_area_2d_body_exited(body: Node2D) -> void:
	enemy_in_range = false
