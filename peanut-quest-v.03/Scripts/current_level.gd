extends Node



@export var current_level : float

@export var respawn_point : Vector2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.connect("respawn_peanut", reload_level)
	
	if current_level == 1.0:
		GameState.current_health = GameState.current_max_health
		GlobalSignalBus.emit_signal("health_check")
	

func reload_level():
	
	get_tree().call_deferred("reload_current_scene")
	GameState.current_health = GameState.current_max_health
