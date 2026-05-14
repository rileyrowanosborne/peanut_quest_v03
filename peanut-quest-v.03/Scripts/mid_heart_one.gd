extends CharacterBody2D






@export var speed : float = 50

var current_dir 

var direction_options = [
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
	Vector2(-1,1)
]


func _ready() -> void:
	current_dir = direction_options.pick_random()


func _physics_process(delta: float) -> void:
	
	var velocity = current_dir.normalized() * speed
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())
