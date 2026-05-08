extends Node2D
#Game script to add to each level, controls whether the player is is shell mode or nakee mode.

#peanut scenes to instantiate
@export var shelled_peanut_scene : PackedScene
@export var naked_peanut_scene : PackedScene

@export var current_respawn_point : Vector2


enum peanut_mode  {
	shelled,
	naked
}

var current_mode : peanut_mode


var current_shelled_peanut_instance
var current_naked_peanut_instance



func _ready():
	
	if GameState.current_health > 0:
		spawn_shelled_player(RoomChangeGlobal.player_pos)
	else:
		spawn_naked_player(RoomChangeGlobal.player_pos)
	
	GlobalSignalBus.connect("health_check", health_check)
	GlobalSignalBus.connect("respawn_peanut", respawn_peanut)


func health_check():
	if GameState.current_health == 0:
		call_deferred("spawn_naked_player", GameState.player_location)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_peanut_mode"):
		if current_mode == peanut_mode.shelled:
			spawn_naked_player(GameState.player_location)
		elif current_mode == peanut_mode.naked:
			spawn_shelled_player(GameState.player_location)


func spawn_shelled_player(world_location : Vector2):
	current_mode = peanut_mode.shelled
	
	if current_naked_peanut_instance:
		if current_naked_peanut_instance.has_method("despawn"):
			current_naked_peanut_instance.despawn()
	
	if shelled_peanut_scene:
		current_shelled_peanut_instance = shelled_peanut_scene.instantiate()
		get_tree().current_scene.add_child(current_shelled_peanut_instance)
		current_shelled_peanut_instance.global_position = world_location



func spawn_naked_player(world_location : Vector2):
	current_mode = peanut_mode.naked
	
	if current_shelled_peanut_instance:
		if current_shelled_peanut_instance.has_method("despawn"):
			current_shelled_peanut_instance.despawn()
	
	if naked_peanut_scene:
		current_naked_peanut_instance = naked_peanut_scene.instantiate()
		get_tree().current_scene.add_child(current_naked_peanut_instance)
		current_naked_peanut_instance.global_position = world_location



func respawn_peanut():
	current_mode = peanut_mode.shelled
	
	GlobalSignalBus.emit_signal("health_check")
	
	if current_naked_peanut_instance:
		if current_naked_peanut_instance.has_method("despawn"):
			current_naked_peanut_instance.despawn()
	
	if shelled_peanut_scene:
		current_shelled_peanut_instance = shelled_peanut_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", current_shelled_peanut_instance)
		current_shelled_peanut_instance.global_position = current_respawn_point
		GameState.current_health = GameState.current_max_health
