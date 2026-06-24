extends Node2D


var is_active : bool = false

@onready var big_axe: Node2D = $BigAxe



func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)
	big_axe.hide()






func class_update():
	if GameState.current_class == "Paladin":
		is_active = true
		big_axe.show()
	else:
		is_active = false
		big_axe.hide()
