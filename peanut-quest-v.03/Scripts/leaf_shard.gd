extends Node2D



@onready var pivot: Node2D = $Pivot




@export var rotation_dir : int = 1
var rotation_speed : float = 50






func _process(delta: float) -> void:
	pivot.rotation_degrees += rotation_speed * rotation_dir * delta
	
