extends Node2D


@onready var launch_timer: Timer = $LaunchTimer


@export var bone_scene : PackedScene


@export var begin_shot_delay : float = 1.0
@export var fire_rate : float = 1.0
@export var bone_direction : Vector2 = Vector2.ZERO
@export var bone_current_rotation : float = 0.0
@export var bone_speed : float = 75.0


func _ready() -> void:
	launch_timer.start(begin_shot_delay)




func spawn_bone(world_location : Vector2):
	if bone_scene:
		var bone_instance = bone_scene.instantiate()
		get_tree().current_scene.add_child(bone_instance)
		bone_instance.speed = bone_speed
		bone_instance.direction = bone_direction
		bone_instance.rotation_degrees = bone_current_rotation
		bone_instance.global_position = world_location
		


func _on_launch_timer_timeout() -> void:
	spawn_bone(global_position)
	launch_timer.start(fire_rate)
