extends Node2D



var deadzone: float = .2
var rotation_speed: float = 5.0

var target_angle: float




func _process(delta: float) -> void:
	
	
	var input_vect: Vector2 = Vector2(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X), Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y))
	
	if input_vect.length() >= deadzone:
		print("heard")
		
		target_angle = input_vect.angle() + deg_to_rad(90.0)
	
	if rotation != target_angle:
		var rotation_lerp_weight: float = 1.0 - exp(-rotation_speed * delta)
		rotation = lerp_angle(rotation, target_angle, rotation_lerp_weight)
	



func _input(event: InputEvent) -> void:
	pass
