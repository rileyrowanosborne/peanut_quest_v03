extends Node2D


var is_active : bool = false




func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)






func class_update():
	if GameState.current_class == "Holy Warrior":
		is_active = true
	else:
		is_active = false
