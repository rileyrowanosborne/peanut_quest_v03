extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var current_rotation : int = 1

var current_dir : Vector2 = Vector2(1,0)

func _process(delta: float) -> void:
	animated_sprite_2d.rotation_degrees += 500 * current_rotation * delta
	
	
	
	if ray_cast_down.is_colliding():
		current_dir = Vector2(1,0)
	
	elif ray_cast_right.is_colliding():
		current_dir = Vector2(0,-1)
	
	elif ray_cast_left.is_colliding():
		current_dir = Vector2(0,1)
	
	elif ray_cast_up.is_colliding():
		current_dir = Vector2(-1,0)
	
	global_position += current_dir * 150 * delta


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)
