extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var target_location : Vector2

var direction_x : float

var speed : float = .1

var no_target : bool = false

var homing_unlocked : bool = false
var laser_unlocked : bool = false

func _ready() -> void:
	if no_target:
		if direction_x == -1:
			animated_sprite_2d.flip_h = true
			ray_cast_left.enabled = true
			ray_cast_right.enabled = false
		elif direction_x == 1:
			animated_sprite_2d.flip_h = false
			ray_cast_right.enabled = true
			ray_cast_left.enabled = false
			
	



func _physics_process(delta: float) -> void:
	if homing_unlocked:
		if no_target:
			global_position.x += direction_x * 100 * delta
		else:
			global_position = lerp(global_position, target_location, .1)
	else:
		global_position.x += direction_x * 100 * delta
	
	if ray_cast_left.is_colliding():
		explode()
	
	if ray_cast_right.is_colliding():
		explode()

func explode():
	print("boom!")
	queue_free()

func default_target():
	no_target = true

func direction_update(direction_input : int):
	direction_x = direction_input

func target_update(target : Vector2):
	target_location = target
	look_at(target_location)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(global_position)
	
	explode()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if no_target:
			no_target = false
			target_location = body.global_position
			animated_sprite_2d.flip_h = false
			look_at(body.global_position)
