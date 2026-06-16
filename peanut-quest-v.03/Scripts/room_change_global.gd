extends Node


var activate : bool = false

var player_pos : Vector2
var player_jump_on_enter : bool

var clear_abilities : bool


func _ready() -> void:
	player_pos = Vector2(40,34)
	
	if clear_abilities:
		GlobalSignalBus.emit_signal("knight_deactivate")
		GlobalSignalBus.emit_signal("mage_deactivate")
		GlobalSignalBus.emit_signal("monk_deactivate")
		GlobalSignalBus.emit_signal("slime_deactivate")
