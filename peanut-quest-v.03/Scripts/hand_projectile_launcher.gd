extends Node2D



@onready var shot_delay: Timer = $ShotDelay


@export var proj_scene : PackedScene
@export var shot_offset : float = 1.0

var player_location : Vector2

func _ready() -> void:
	shot_delay.start(shot_offset)

func _process(delta: float) -> void:
	player_location = Vector2(GameState.player_location.x, GameState.player_location.y -60)
	


func spawn_projectile():
	if proj_scene:
		var proj_instance = proj_scene.instantiate()
		get_tree().current_scene.add_child(proj_instance)
		proj_instance.global_position = global_position
		proj_instance.direction = (player_location - global_position).normalized()



func _on_shot_delay_timeout() -> void:
	spawn_projectile()
	
	
	shot_delay.start()
