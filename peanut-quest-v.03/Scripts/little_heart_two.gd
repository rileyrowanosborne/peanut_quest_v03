extends Node2D

@onready var pivot: Node2D = $Pivot




var rotation_speed : float = 25







func _process(delta: float) -> void:
	
	pivot.rotation_degrees += rotation_speed * delta
