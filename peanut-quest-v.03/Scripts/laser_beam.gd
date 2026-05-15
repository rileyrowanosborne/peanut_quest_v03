@tool
extends Node2D





@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var right_line: Line2D = $RayCastRight/RightLine
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var left_line: Line2D = $RayCast2DLeft/LeftLine



@export var cast_speed:= 7000.0
@export var max_length : = 1400.0



func _physics_process(delta: float) -> void:
	ray_cast_2d_left.target_position.x = move_toward(ray_cast_2d_left.target_position.x, max_length, cast_speed * delta)
