extends CharacterBody2D




var speed : float = 20
var current_direction : int

@onready var direction_cooldown: Timer = $DirectionCooldown
@onready var direction_timer: Timer = $DirectionTimer

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	current_direction = 1
	direction_cooldown.start()



func _process(delta: float) -> void:
	if ray_cast_left.is_colliding():
		current_direction = 1
	
	if ray_cast_right.is_colliding():
		current_direction = -1
	
	if current_direction == 1:
		animated_sprite_2d.flip_h = false
	if current_direction == -1:
		animated_sprite_2d.flip_h = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = speed * current_direction
	
	move_and_slide()
	


func change_dir():
	current_direction = randf_range(-1,1)
	
	direction_cooldown.start()
