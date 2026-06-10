extends TextureProgressBar







# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.connect("create_health_bar", create_boss_health_bar)
	GlobalSignalBus.connect("boss_health_update", health_bar_update)



func create_boss_health_bar():
	show()
	max_value = GameState.current_boss_health




func health_bar_update():
	value = GameState.current_boss_health
