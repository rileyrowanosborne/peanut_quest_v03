extends Node2D




var total_health : int

var direction : Vector2

func _ready() -> void:
	direction = Vector2((randf_range(-1,1)), randf_range(-1,1))
	
	print(GameState.current_boss_health)
	
	


func health_check():
	print(GameState.current_boss_health)
	GlobalSignalBus.emit_signal("boss_health_update")

func eye_death():
	pass
