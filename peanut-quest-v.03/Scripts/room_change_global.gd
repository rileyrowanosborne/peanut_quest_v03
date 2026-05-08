extends Node


var activate : bool = false

var player_pos : Vector2
var player_jump_on_enter : bool


func _ready() -> void:
	player_pos = Vector2(40,34)
