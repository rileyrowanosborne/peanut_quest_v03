extends Node2D


var is_active : bool = false

@onready var mega_sword: Node2D = $MegaSword




func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)
	mega_sword.hide()






func class_update():
	if GameState.current_class == "Knight":
		is_active = true
		mega_sword.show()
	else:
		is_active = false
		mega_sword.hide()
