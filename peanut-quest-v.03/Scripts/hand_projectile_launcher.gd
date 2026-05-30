extends Node2D



@onready var shot_delay: Timer = $ShotDelay


@export var proj_scene : PackedScene
@export var shot_offset : float = 1.0


var is_firing : bool = false

var player_location : Vector2

func _ready() -> void:
	shot_delay.start(shot_offset)



func spawn_projectile():
	if proj_scene:
		var proj_instance = proj_scene.instantiate()
		get_tree().current_scene.add_child(proj_instance)
		proj_instance.global_position = global_position
		proj_instance.direction = (GameState.player_center_location - global_position).normalized()
		print(proj_instance.direction)



func _on_shot_delay_timeout() -> void:
	if is_firing:
		spawn_projectile()
	
	
	shot_delay.start()
