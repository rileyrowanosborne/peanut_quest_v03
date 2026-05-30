extends CharacterBody2D






@export var speed : float = 50
var current_dir : Vector2
var direction_options = [
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
	Vector2(-1,1)
]
@export var is_moving : bool = true





func _ready() -> void:
	if is_moving:
		current_dir = direction_options.pick_random()
	
	else:
		current_dir = Vector2.ZERO
	
	add_to_group("enemy")



func _physics_process(delta: float) -> void:
	
	var movement_velocity = current_dir.normalized() * speed
	
	velocity = movement_velocity
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())
	
	
