extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction_x : float

var speed : float = 100


func _ready() -> void:
	if direction_x == -1:
		animated_sprite_2d.flip_h = true
		ray_cast_left.enabled = true
		ray_cast_right.enabled = false
	elif direction_x == 1:
		animated_sprite_2d.flip_h = false
		ray_cast_right.enabled = true
		ray_cast_left.enabled = false



func _physics_process(delta: float) -> void:
	global_position.x += direction_x * speed * delta
	
	if ray_cast_left.is_colliding():
		explode()
	
	if ray_cast_right.is_colliding():
		explode()

func explode():
	print("boom!")
	queue_free()


func direction_update(direction_input : int):
	
	direction_x = direction_input
	
	
