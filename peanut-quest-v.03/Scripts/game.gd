extends Node2D
#Game script to add to each level, controls whether the player is is shell mode or nakee mode.

#peanut scenes to instantiate
@export var shelled_peanut_scene : PackedScene
@export var naked_peanut_scene : PackedScene


enum peanut_mode  {
	shelled,
	naked
}

var current_mode : peanut_mode

var spawn_point : Vector2 = Vector2(-57,-56)

var current_shelled_peanut_instance
var current_naked_peanut_instance



func _ready() -> void:
	spawn_shelled_player(spawn_point)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_peanut_mode"):
		if current_mode == peanut_mode.shelled:
			spawn_naked_player(GameState.player_location)
		elif current_mode == peanut_mode.naked:
			spawn_shelled_player(GameState.player_location)


func spawn_shelled_player(world_location : Vector2):
	current_mode = peanut_mode.shelled
	
	if shelled_peanut_scene:
		current_shelled_peanut_instance = shelled_peanut_scene.instantiate()
		get_tree().current_scene.add_child(current_shelled_peanut_instance)
		current_shelled_peanut_instance.global_position = world_location
		if current_naked_peanut_instance:
			if current_naked_peanut_instance.has_method("despawn"):
				current_naked_peanut_instance.despawn()


func spawn_naked_player(world_location : Vector2):
	current_mode = peanut_mode.naked
	
	if naked_peanut_scene:
		current_naked_peanut_instance = naked_peanut_scene.instantiate()
		get_tree().current_scene.add_child(current_naked_peanut_instance)
		current_naked_peanut_instance.global_position = world_location
		if current_shelled_peanut_instance:
			if current_shelled_peanut_instance.has_method("despawn"):
				current_shelled_peanut_instance.despawn()

	
