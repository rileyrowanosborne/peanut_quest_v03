extends Node2D

@onready var shot_delay_timer: Timer = $ShotDelayTimer


@export var shot_delay : float = 1.0
@export var aiming_direction : Vector2 = Vector2(1,0)
@export var projectile_scene : PackedScene

func _ready() -> void:
	shot_delay_timer.wait_time = shot_delay




func spawn_projectile():
	if projectile_scene:
		var projectile_instance = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile_instance)
		projectile_instance.global_position = global_position
		projectile_instance.direction = aiming_direction
		

func _on_shot_delay_timer_timeout() -> void:
	spawn_projectile()
