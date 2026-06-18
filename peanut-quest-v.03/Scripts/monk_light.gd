extends Node2D



func _process(delta: float) -> void:
	
	rotation_degrees -= GameState.monk_rotation_amount * delta
