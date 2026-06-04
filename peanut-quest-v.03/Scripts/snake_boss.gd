extends Node2D


var direction

func _ready() -> void:
	direction = Vector2((randf_range(-1,1)), randf_range(-1,1))
	
