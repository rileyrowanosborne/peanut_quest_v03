extends Node



@export var current_level : float

@export var respawn_point : Vector2

@export var peanut_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.emit_signal("essence_update")
	GlobalSignalBus.emit_signal("salt_update")
	
	GlobalSignalBus.connect("respawn_peanut", reload_level)
	
	GlobalSignalBus.connect("reshell_complete", reshell_peanut)
	
	if GameState.first_load:
		GameState.first_load = false
		GameState.current_health = GameState.current_max_health
		GlobalSignalBus.emit_signal("health_check")
	

func reload_level():
	GameState.current_brain_essence = 0
	get_tree().reload_current_scene()
	GameState.current_health = GameState.current_max_health


func reshell_peanut():
	GlobalSignalBus.emit_signal("essence_update")
	GlobalSignalBus.emit_signal("salt_update")
	spawn_peanut(GameState.player_location)


func spawn_peanut(world_location : Vector2):
	if peanut_scene:
		var peanut_instance = peanut_scene.instantiate()
		get_tree().current_scene.add_child(peanut_instance)
		peanut_instance.global_position = world_location
